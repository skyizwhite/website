// Nagi v0.5.0
// Forked from Nomini (https://github.com/nonnorm/nomini)
// Inspired by aidenybai/dababy
// Copyright (c) 2025 nonnorm
// Copyright (c) 2026 Akira Tempaku
// Licensed under the MIT License.

(() => {
    // Important reactivity stuff
    let currentBind = null;
    let currentEl = null;
    let currentHandler = null;

    // Utility functions
    const dispatch = (el, name, opts) => el.dispatchEvent(new CustomEvent(name, { bubbles: true, detail: {}, ...opts }));

    const failed = Symbol();

    const descriptorOf = (obj, prop) => {
        for (let o = obj; o; o = Object.getPrototypeOf(o)) {
            const found = Object.getOwnPropertyDescriptor(o, prop);
            if (found) return found;
        }
    };

    const define = (obj, key, value) =>
        Object.defineProperty(obj, key, { value, writable: true, enumerable: true, configurable: true });

    const evaluate = (expression, data, thisArg, el) => {
        try {
            return new Function("__data", "$el", `with(__data) {return (${expression}\n)}`).call(thisArg, data, el);
        } catch (err) {
            console.error("[Nagi] failed to evaluate:", expression, "\n", err);
            return failed;
        }
    };

    const queryAttr = (el, selector) => {
        const elMatch = el.matches(selector) ? [el] : [];
        return [...elMatch, ...el.querySelectorAll(selector)].filter((val) => !val.closest("[n-ignore]"));
    };

    const closestScope = (el) => {
        for (; el; el = el.parentElement) if (el.nagiProxy) return el;
    };

    const ownScopes = new WeakMap();
    const getClosestProxy = (el) => {
        const scope = closestScope(el)?.nagiProxy;
        if (scope) return scope;
        if (!ownScopes.has(el)) ownScopes.set(el, reactive({ ...helpers(), _nagiEl: el }));
        return ownScopes.get(el);
    };

    const hostOf = (scope) => currentEl ?? scope._nagiEl;

    const runWithEl = (el, fn, bind = null, handler = null) => {
        const prev = [currentEl, currentBind, currentHandler];
        [currentEl, currentBind, currentHandler] = [el, bind, handler];
        try {
            return fn();
        } finally {
            [currentEl, currentBind, currentHandler] = prev;
        }
    };

    const unlink = (run) => {
        run.deps.forEach((deps) => deps.delete(run));
        run.deps.clear();
        run.children.forEach(kill);
        run.children = [];
    };

    const kill = (run) => {
        run.gone = true;
        run.owner?.nagiRuns.delete(run);
        unlink(run);
    };

    let runCount = 0;

    const watch = (fn, el = currentEl, owner = el) => {
        const run = () => {
            if (run.gone || run === currentBind) return;
            if (run.active) return (run.dirty = true);
            run.active = true;
            try {
                for (let i = 0; i < 100 && !run.gone && (i === 0 || run.dirty); i++) {
                    run.dirty = false;
                    unlink(run);
                    try {
                        runWithEl(el, fn, run);
                    } catch (err) {
                        console.error("[Nagi] failed to run:", fn, "\n", err);
                    }
                }
                if (run.gone) unlink(run);
                else if (run.dirty) console.error("[Nagi] stopped running after 100 times:", fn);
            } finally {
                run.active = false;
            }
        };
        Object.assign(run, { owner, deps: new Set(), children: [] });
        owner && (owner.nagiRuns ||= new Set()).add(run);
        run.key = currentBind ? `${currentBind.key}.${currentBind.children.length}` : `run${++runCount}`;
        currentBind?.children.push(run);
        run();
        return run;
    };

    // Helpers that are included with every data object
    const helpers = (pending = 0, writing = new Set(), controllers = new Set(), read = null) => ({
        $refs: {},
        $fetching: false,
        _nagiAbort: new AbortController(),
        ...Object.fromEntries(
            ["GET", "POST", "PUT", "PATCH", "DELETE"].map((method) => [
                `$${method.toLowerCase()}`,
                function (url, data, options) {
                    this.$fetch(url, method, data, options);
                },
            ]),
        ),
        $abort() {
            controllers.forEach((controller) => controller.abort());
            this._nagiStop();
        },
        _nagiStop() {
            read?.abort();
            this._nagiAbort.abort();
            this._nagiAbort = new AbortController();
        },
        $fetch(url, method, data, options) {
            options ??= {};
            const el = hostOf(this);
            const controller = new AbortController();
            const { signal } = controller;
            method = (method || "GET").toUpperCase();
            url = String(url);
            const reading = /^(GET|HEAD|OPTIONS)$/.test(method);
            const inQuery = /^(GET|HEAD|DELETE)$/.test(method);
            const dedupe = options.dedupe !== false;
            const report = (name, detail, cancelable = false) =>
                dispatch(el?.isConnected ? el : document, name, { detail, cancelable });
            let write;

            const opts = runWithEl(el, () => {
                const body = bodyOf(data);
                const entries = [...body];
                const opts = { headers: { "n-request": true }, method, signal };
                if (inQuery) {
                    if (entries.some(([, value]) => typeof value !== "string"))
                        console.warn("[Nagi] files are not sent with", method, url);
                    url = withQuery(url, String(new URLSearchParams(entries.filter(([, value]) => typeof value === "string"))));
                } else opts.body = body;

                write = !reading && `${method} ${url} ${opts.body ? new URLSearchParams(sentOf(entries)) : ""}`;
                if (dedupe && writing.has(write)) return;

                read?.abort();
                this._nagiAbort.abort();
                return opts;
            });

            if (!opts) {
                report("fetchskip", { method, url });
                return;
            }

            this._nagiAbort = new AbortController();
            if (reading) read = controller;
            if (reading && el) el.nagiRead = controller;
            const deduped = write && dedupe;
            if (deduped) writing.add(write);
            controllers.add(controller);
            let timedOut = false;
            let received = false;
            const { timeout } = options;
            const timer = Number.isFinite(timeout) && timeout > 0 && setTimeout(() => {
                timedOut = true;
                controller.abort();
            }, Math.min(timeout, 2147483647));
            pending++;
            this.$fetching = true;

            fetch(url, opts)
                .then(async (res) => {
                    const redirect = res.headers.get("n-redirect");
                    if (redirect) {
                        res.body?.cancel();
                        if (!signal.aborted && report("fetchredirect", { url: redirect }, true)) location.assign(redirect);
                        return;
                    }

                    const text = await readText(res.body);
                    if (signal.aborted) return;
                    received = true;

                    const swapped = res.ok || fragmentsOf(text).some((child) => child.id && document.getElementById(child.id));

                    const replace = res.headers.get("n-replace-url");
                    if (replace) {
                        try {
                            history.replaceState(history.state, "", replace);
                        } catch (err) {
                            console.warn("[Nagi] cannot replace the URL with", replace, err);
                        }
                    }
                    if (swapped) swap(text);
                    if (!res.ok)
                        throw Object.assign(new Error(`${res.status} ${res.statusText}`), { status: res.status, text, swapped });
                })
                .catch((err) => {
                    if (timedOut) err = new DOMException("The request timed out.", "TimeoutError");
                    else if (signal.aborted && !received) return;
                    report("fetcherr", { err, url, status: err?.status, text: err?.text, swapped: !!err?.swapped });
                })
                .finally(() => {
                    clearTimeout(timer);
                    controllers.delete(controller);
                    if (read === controller) read = null;
                    if (el?.nagiRead === controller) el.nagiRead = null;
                    if (deduped) writing.delete(write);
                    if (!--pending) this.$fetching = false;
                });
        },
        $dataset() {
            let datasets = {};
            for (let el = hostOf(this); el?.nodeType === 1; el = el.parentElement) datasets = { ...el.dataset, ...datasets };
            return datasets;
        },
        $watch: (fn) => void watch(fn),
        $dispatch(evt, detail, opts) {
            dispatch(hostOf(this) ?? document, evt, { detail, ...opts });
        },
        $debounce(fn, ms, abortable = false) {
            const el = hostOf(this);
            const signal = abortable && runWithEl(el, () => this._nagiAbort?.signal);
            const timers = ((el ?? document).nagiTimers ||= new Map());
            const key = currentHandler ?? currentBind?.key ?? fn.nagiSource ?? String(fn);
            clearTimeout(timers.get(key));
            timers.set(key, setTimeout(() => {
                timers.delete(key);
                if (!signal?.aborted) runWithEl(el, fn);
            }, ms));
        },
        $persist(prop, key) {
            key = key || `_nagiProp-${prop}`;

            const stored = localStorage[key];
            if (stored) this[prop] = JSON.parse(stored);

            watch(() => {
                localStorage[key] = JSON.stringify(this[prop]);
            });
        },
    });

    const fileIds = new WeakMap();
    let fileCount = 0;
    const idOf = (file) => {
        if (!fileIds.has(file)) fileIds.set(file, ++fileCount);
        return fileIds.get(file);
    };

    const isBlob = (value) => typeof value?.arrayBuffer === "function";
    const isListOf = (value, method) => typeof value?.[method] === "function" && typeof value[Symbol.iterator] === "function";

    const formBody = (data) => {
        const isEvent = typeof data.preventDefault === "function";
        const node = isEvent ? data.target : data;
        const button = node?.closest?.("button, input[type=submit], input[type=image]");
        const form = node?.tagName === "FORM" ? node : (button ?? node)?.form ?? node?.closest?.("form");
        if (!form) {
            console.warn("[Nagi] no form to send for:", data);
            return new URLSearchParams();
        }
        const submitter = isEvent && data.submitter;
        const body = new FormData(form, submitter || undefined);
        if (button?.name && button !== submitter && button.form === form) body.append(button.name, button.value);
        return body;
    };

    const sendable = (key, item) => {
        if (item !== Object(item) || isBlob(item) || !String(item).startsWith("[object ")) return true;
        console.warn("[Nagi] cannot send:", key, item);
    };

    const objectBody = (data) => {
        const pairs = Object.entries(data ?? {}).flatMap(([key, value]) =>
            [value]
                .flat()
                .flatMap((item) => (isListOf(item, "item") ? [...item] : [item]))
                .filter((item) => item != null && sendable(key, item))
                .map((item) => [key, isBlob(item) ? item : String(item)]),
        );
        const body = pairs.some(([, value]) => isBlob(value)) ? new FormData() : new URLSearchParams();
        pairs.forEach(([key, value]) => body.append(key, value));
        return body;
    };

    const bodyOf = (data) => {
        if (typeof data === "string") return new URLSearchParams(data);
        if (typeof data?.preventDefault === "function" || data?.nodeType === 1) return formBody(data);
        if (isListOf(data, "append")) return data;
        return objectBody(data);
    };

    const withQuery = (url, query) => {
        if (!query) return url;
        const hashAt = url.includes("#") ? url.indexOf("#") : url.length;
        const path = url.slice(0, hashAt);
        const joiner = !path.includes("?") ? "?" : /[?&]$/.test(path) ? "" : "&";
        return path + joiner + query + url.slice(hashAt);
    };

    const sentOf = (entries) =>
        entries.map(([key, value]) => [
            key,
            typeof value === "string" ? value : value.size || value.name ? `\0file${idOf(value)}` : "\0empty",
        ]);

    const readText = async (body) => {
        let text = "";
        if (!body) return text;
        const stream = body.pipeThrough(new TextDecoderStream()).getReader();
        for (let chunk; !(chunk = await stream.read()).done; ) text += chunk.value;
        return text;
    };

    const fragmentsOf = (text) => {
        const template = document.createElement("template");
        template.innerHTML = text;
        return [...template.content.children];
    };

    const drop = (el) => {
        queryAttr(el, "*").forEach((node) => node.nagiBound && dispatch(node, "destroy", { bubbles: false }));
        queryAttr(el, "[n-ref]").forEach((node) => {
            const refs = closestScope(node)?.nagiProxy.$refs;
            const name = node.getAttribute("n-ref");
            if (refs?.[name] === node) delete refs[name];
        });
        [el, ...el.querySelectorAll("*")].forEach((node) => {
            (node.nagiProxy ?? ownScopes.get(node))?._nagiStop();
            node.nagiRead?.abort();
            node.nagiRuns?.forEach(kill);
            node.nagiCleanup?.forEach((clean) => clean());
            node.nagiTimers?.forEach(clearTimeout);
            node.nagiTimers?.clear();
        });
    };

    const initAll = (nodes) => nodes.forEach((node) => node.nodeType === 1 && init(node));

    const swap = (text) => {
        for (const fragment of fragmentsOf(text)) {
            const strategy = fragment.getAttribute("n-swap") || "outer";
            const target = fragment.id && document.getElementById(fragment.id);
            if (!fragment.id) { console.warn("[Nagi] Fragment is missing an id: ", fragment); continue; }
            if (!target) { console.warn("[Nagi] Swap target not found: #", fragment.id); continue; }
            if (!/^(inner|outer|before|after|prepend|append)$/.test(strategy)) { console.error("[Nagi] Invalid swap strategy: ", strategy); continue; }

            const kids = [...fragment.childNodes];

            const settles = (strategy === "outer" ? [fragment] : kids.filter((kid) => kid.nodeType === 1)).map(cssMorph);

            if (strategy === "inner") {
                [...target.children].forEach(drop);
                target.replaceChildren(...kids);
                initAll([...target.childNodes]);
            } else if (strategy === "outer") {
                drop(target);
                target.replaceWith(fragment);
                init(fragment);
            } else {
                target[strategy](...kids);
                initAll(kids);
            }

            settles.forEach((settle) => settle());
        }
    };

    const attributesToSettle = ["style", "class", "height", "width"];
    const readSettled = (el) => attributesToSettle.map((attr) => [attr, el.getAttribute(attr)]);

    const cssMorph = (fragment) => {
        const pairs = queryAttr(fragment, "[id]").flatMap((newEl) => {
            const oldEl = document.getElementById(newEl.id);
            return oldEl && oldEl.tagName === newEl.tagName ? [[newEl, readSettled(oldEl)]] : [];
        });

        return () =>
            pairs.forEach(([newEl, oldValues]) => {
                const apply = (values) =>
                    values.forEach(([attr, value]) =>
                        value != null ? newEl.setAttribute(attr, value) : newEl.removeAttribute(attr),
                    );
                const settled = readSettled(newEl);
                apply(oldValues);
                requestAnimationFrame(() => {
                    apply(settled);
                    newEl.nagiRuns?.forEach((run) => attributesToSettle.includes(run.attr) && run());
                });
            });
    };

    const reserved = (key, el) => {
        if (!/^(\$|_nagi|__proto__$)/i.test(key)) return false;
        console.error("[Nagi] this name is Nagi's own:", key, el);
        return true;
    };

    const builtIn = (obj) => {
        for (let p = Object.getPrototypeOf(obj); p && Object.getPrototypeOf(p); p = Object.getPrototypeOf(p))
            if (Object.hasOwn(p, "constructor") && /\[native code\]/.test(Function.prototype.toString.call(p.constructor)))
                return true;
    };

    const baseOf = (dataEl) => {
        const base = dataEl.getAttribute("n-scope")?.trim();
        const made = base ? evaluate(base, {}, Object.freeze({}), dataEl) : {};
        try {
            if (made !== null && typeof made === "object" && typeof made.then !== "function" && !builtIn(made)) {
                const descriptors = Object.getOwnPropertyDescriptors(made);
                Object.keys(descriptors).forEach((key) => reserved(key, dataEl) && delete descriptors[key]);
                Object.values(descriptors).forEach((d) => {
                    d.configurable = true;
                    if ("value" in d) d.writable = true;
                });
                return Object.create(Object.getPrototypeOf(made), descriptors);
            }
            if (made !== failed) console.error("[Nagi] n-scope must give an object:", base, dataEl);
        } catch (err) {
            console.error("[Nagi] failed to read the object of n-scope:", base, dataEl, "\n", err);
        }
        return {};
    };

    const announcers = new WeakMap();

    const reactive = (rawData, outer) => {
        const trackedDeps = new Map();
        const fromOuter = (obj, prop) => !(prop in obj) && !!outer && prop in outer;
        const bound = new WeakMap();
        const bindToOuter = (fn) => {
            if (!bound.has(fn)) bound.set(fn, Object.assign(fn.bind(outer), { nagiSource: fn.nagiSource ?? String(fn) }));
            return bound.get(fn);
        };
        const track = (prop) => {
            if (!currentBind) return;
            const deps = trackedDeps.get(prop) ?? trackedDeps.set(prop, new Set()).get(prop);
            deps.add(currentBind);
            currentBind.deps.add(deps);
        };
        const announce = (prop) => {
            const deps = trackedDeps.get(prop);
            deps && [...deps].forEach((run) => run());
        };

        const proxy = new Proxy(rawData, {
            has(obj, prop) {
                if (prop === "$el") return false;
                if (prop in obj) return true;
                track(prop);
                return !!outer && prop in outer;
            },
            get(obj, prop, receiver) {
                track(prop);
                if (fromOuter(obj, prop)) {
                    const value = outer[prop];
                    return typeof value === "function" ? bindToOuter(value) : value;
                }
                if (currentBind && outer && !(prop in obj)) outer[prop];
                return Reflect.get(obj, prop, receiver);
            },
            set(obj, prop, val, receiver) {
                if (fromOuter(obj, prop)) return Reflect.set(outer, prop, val);
                const found = descriptorOf(obj, prop);
                if (found && "value" in found && val !== Object(val) && Object.is(obj[prop], val)) return true;
                if (!Reflect.set(obj, prop, val, receiver)) return false;
                announce(prop);
                return true;
            },
        });
        announcers.set(proxy, announce);
        return proxy;
    };

    const announceName = (scopeEl, key) => announcers.get(scopeEl.nagiProxy)(key);

    const giveName = (scopeEl, key, value) => {
        define(scopeEl.nagiRaw, key, value);
        announceName(scopeEl, key);
    };

    const makeScope = (dataEl) => {
        if (dataEl.nagiProxy) return;
        const attrs = [...dataEl.attributes];
        if (!dataEl.hasAttribute("n-scope")) {
            if (attrs.some(({ name }) => name.startsWith("n-let-"))) console.error("[Nagi] n-let-* needs n-scope on its element:", dataEl);
            return;
        }

        const rawData = baseOf(dataEl);
        Object.entries({ ...helpers(), _nagiEl: dataEl }).forEach(([key, value]) => define(rawData, key, value));

        const outer = closestScope(dataEl.parentElement)?.nagiProxy;
        const proxyData = reactive(rawData, outer);

        dataEl.nagiProxy = proxyData;
        dataEl.nagiRaw = rawData;

        attrs.forEach(({ name, value }) => {
            const key = name.match(/^n-let-(.+)$/)?.[1];
            if (!key || reserved(key, dataEl)) return;
            const result = value.trim() ? runWithEl(dataEl, () => evaluate(value, proxyData, proxyData, dataEl)) : undefined;
            if (result === failed) return;
            try {
                if (!(key in rawData) || !Reflect.set(proxyData, key, result)) giveName(dataEl, key, result);
            } catch (err) {
                console.error("[Nagi] failed to set:", key, dataEl, "\n", err);
            }
        });
    };

    const formScope = (el) => closestScope(el.closest("[n-form]"));

    const isField = (el) => /^(SELECT|TEXTAREA)$/.test(el.tagName) || (el.tagName === "INPUT" && !/^(submit|image|button|reset)$/.test(el.type));

    const formFields = new Set();
    document.addEventListener("reset", (e) =>
        setTimeout(() =>
            formFields.forEach((field) => {
                if (!field.inputEl.isConnected) formFields.delete(field);
                else if (field.inputEl.form === e.target) field.setVal();
            }),
        ), true);

    const hasName = (raw, name) => {
        for (let o = raw; o && o !== Object.prototype; o = Object.getPrototypeOf(o)) if (Object.hasOwn(o, name)) return true;
        return false;
    };

    const fieldOf = (inputEl, scopeEl) => {
        const { nagiProxy: proxyData, nagiRaw: rawData } = scopeEl;
        const { name, type, form } = inputEl;
        const radio = type === "radio";
        const owned = (scopeEl.nagiFields ||= new Map());
        let group = owned.get(name);
        const fresh = !group;
        group?.members.forEach((el) => el.isConnected || group.members.delete(el));
        if (group?.members.size && !(radio && group.radio && group.form === form))
            return console.error("[Nagi] another field of the form has this name:", name, inputEl);
        if (!group) {
            if (hasName(rawData, name)) return console.error("[Nagi] this field's name is already a name of the scope:", name, inputEl);
            define(rawData, name, undefined);
            owned.set(name, (group = { members: new Set() }));
        }
        Object.assign(group, { radio, form });
        group.members.add(inputEl);

        const read = {
            radio: () => [...group.members].find((el) => el.isConnected && el.form === inputEl.form && el.checked)?.value,
            checkbox: () => inputEl.checked,
            file: () => inputEl.files,
            number: () => (inputEl.value === "" ? undefined : +inputEl.value),
            range: () => +inputEl.value,
            "select-multiple": () => [...inputEl.selectedOptions].map((option) => option.value),
        }[type] ?? (() => inputEl.value);
        const setVal = () => {
            if (group.members.has(inputEl)) proxyData[name] = read();
        };
        const field = { inputEl, setVal };

        setVal();
        if (fresh && read() === undefined) announceName(scopeEl, name);
        inputEl.addEventListener("input", setVal);
        inputEl.addEventListener("change", setVal);
        formFields.add(field);
        (inputEl.nagiCleanup ||= []).push(() => {
            group.members.delete(inputEl);
            formFields.delete(field);
        });
    };

    const propOf = (obj, name) => {
        for (let o = obj; o; o = Object.getPrototypeOf(o))
            for (const key of Object.getOwnPropertyNames(o)) if (key.toLowerCase() === name) return key;
    };

    const writable = (obj, key) => {
        const found = descriptorOf(obj, key);
        return !found || !!(found.set || found.writable);
    };

    const unset = (value) => value == null || value === false;

    const keyedWriters = {
        __proto__: null,
        class: (el, sub, value) => el.classList.toggle(sub, !!value),
        style: (el, sub, value) => (unset(value) ? el.style.removeProperty(sub) : el.style.setProperty(sub, value)),
        dataset: (el, sub, value) =>
            unset(value) ? el.removeAttribute("data-" + sub) : el.setAttribute("data-" + sub, value),
    };

    const sourceOf = (bindEl, name, value) => {
        const [, kind, rest] = name.match(/^n-(bind|on)-(.+)$/) || [];
        if (kind === "on") {
            if (/^\s*(async\s+)?(\([^)]*\)|[\w$]+)\s*=>/.test(value))
                console.warn("[Nagi] n-on-* runs statements, and this only makes a function:", name, bindEl);
            return `${JSON.stringify("@" + rest)}: async (e) => {${value}\n}`;
        }
        if (!kind) return;

        const [first, ...subs] = rest.split(".");
        const sub = subs.join(".");
        const main = first === "class" ? first : propOf(bindEl, first);
        const keyed = !!main && main in keyedWriters;
        const inner = !sub || keyed ? sub : propOf(bindEl[main], sub);
        if (!main || inner === undefined) return console.error("[Nagi] no such property:", name, bindEl);

        const camelSub = sub.replace(/-(\w)/g, (_, c) => c.toUpperCase());
        if (main === "style" && sub && !sub.startsWith("--") && !(sub in bindEl.style) && !(camelSub in bindEl.style))
            console.warn("[Nagi] the style has no such property:", name, bindEl);
        if (!(sub && keyed) && !(sub ? writable(bindEl[main], inner) : writable(bindEl, main)))
            return console.error("[Nagi] cannot write:", name, bindEl);

        const key = main + (sub ? "." + inner : "");
        const body = value.replace(/[\s;]+$/, "");
        const empty = !body.replace(/\/\*[\s\S]*?\*\/|\/\/[^\n]*/g, "").trim();
        return `${JSON.stringify(key)}: () => (${empty ? "undefined" : body}\n)`;
    };

    const classesOf = (v) =>
        typeof v === "string" ? v.split(/\s+/)
            : Array.isArray(v) ? v.filter(Boolean).flatMap((item) => String(item).split(/\s+/))
            : Object.keys(v ?? {}).filter((name) => v[name]).flatMap((name) => name.split(/\s+/));

    const writerOf = (bindEl, main, sub) => {
        if (sub && main in keyedWriters) return (value) => keyedWriters[main](bindEl, sub, value);
        if (sub) return (value) => (bindEl[main][sub] = value);
        if (main === "disabled") return (value) => bindEl.nagiHeld || (bindEl.disabled = value);
        if (main !== "class") return (value) => (bindEl[main] = value);

        let added = new Set();
        return (value) => {
            const next = new Set(classesOf(value).filter(Boolean));
            const mine = new Set();
            added.forEach((name) => next.has(name) || bindEl.classList.remove(name));
            next.forEach((name) => {
                if (added.has(name) || !bindEl.classList.contains(name)) mine.add(name);
                bindEl.classList.add(name);
            });
            added = mine;
        };
    };

    const handle = (val, e) => val(e)?.catch?.((err) => console.error("[Nagi] failed to run:", val, "\n", err));

    const listen = (bindEl, key, val, proxyData) => {
        const [eventName, ...mods] = key.split(".");
        const unknown = mods.filter((mod) => !/^(prevent|stop|once|window|debounce\d+)$/.test(mod));
        if (unknown.length) console.warn("[Nagi] unknown modifiers:", unknown, bindEl);

        const delay = +mods.find((mod) => mod.startsWith("debounce"))?.slice(8);

        const listener = (e) => runWithEl(bindEl, () => {
            if (mods.includes("prevent")) e.preventDefault();
            if (mods.includes("stop")) e.stopPropagation();

            if (delay) proxyData.$debounce(() => handle(val, e), delay);
            else handle(val, e);
        }, null, val);

        const listenOn = mods.includes("window") ? window : bindEl;
        listenOn.addEventListener(eventName, listener, { once: mods.includes("once") });
        if (listenOn === window) (bindEl.nagiCleanup ||= []).push(() => window.removeEventListener(eventName, listener));
    };

    const bindProp = (bindEl, key, val) => {
        const [main, ...rest] = key.split(".");
        const write = writerOf(bindEl, main, rest.join("."));
        let latest = 0;
        const run = watch(() => {
            const value = val();
            const mine = ++latest;
            if (typeof value?.then !== "function") return write(value);
            value
                .then((resolved) => mine === latest && !run?.gone && write(resolved))
                .catch((err) => console.error("[Nagi] failed to run:", val, "\n", err));
        }, bindEl);
        run.attr = /^class(name|list)$/i.test(main) ? "class" : main;
    };

    const init = (baseEl) => {
        const walker = document.createTreeWalker(baseEl, NodeFilter.SHOW_ELEMENT, {
            acceptNode: (node) => (node.hasAttribute("n-ignore") ? NodeFilter.FILTER_REJECT : NodeFilter.FILTER_ACCEPT),
        });
        const seen = new Set();
        let dataEl = baseEl.closest("[n-ignore]") ? null : baseEl;
        while (dataEl) {
            const parent = dataEl.parentElement;
            const before = dataEl.previousElementSibling;
            seen.add(dataEl);
            makeScope(dataEl);
            const moved = dataEl.parentElement !== parent || dataEl.previousElementSibling !== before;
            walker.currentNode = dataEl !== baseEl && (moved || !baseEl.contains(dataEl)) ? baseEl : dataEl;
            do dataEl = walker.nextNode();
            while (dataEl && seen.has(dataEl));
        }

        queryAttr(baseEl, "[n-ref]").forEach((el) => {
            const scope = closestScope(el)?.nagiProxy;
            if (!scope) return console.error("[Nagi] n-ref needs a scope:", el);
            scope.$refs[el.getAttribute("n-ref")] = el;
        });

        queryAttr(baseEl, "[n-form]").forEach((form) => closestScope(form) || console.error("[Nagi] n-form needs a scope:", form));

        queryAttr(baseEl, "[name]").filter(isField).forEach((inputEl) => {
            const scopeEl = formScope(inputEl);
            if (scopeEl && !reserved(inputEl.name, inputEl)) fieldOf(inputEl, scopeEl);
        });

        queryAttr(baseEl, "button, input[type=submit], input[type=image]").forEach((submitEl) => {
            const proxyData = formScope(submitEl)?.nagiProxy;
            if (!proxyData || !submitEl.form) return;
            let wasDisabled = false;
            watch(() => {
                const fetching = proxyData.$fetching;
                if (fetching && !submitEl.nagiHeld && /^(submit|image)$/.test(submitEl.type)) {
                    wasDisabled = submitEl.disabled;
                    submitEl.disabled = submitEl.nagiHeld = true;
                } else if (!fetching && submitEl.nagiHeld) {
                    submitEl.nagiHeld = false;
                    if (!wasDisabled) submitEl.disabled = false;
                    submitEl.nagiRuns?.forEach((run) => run.attr === "disabled" && run());
                }
            }, submitEl);
        });

        queryAttr(baseEl, "*").forEach((bindEl) => {
            if (bindEl.nagiBound) return;
            const entries = [...bindEl.attributes].map(({ name, value }) => sourceOf(bindEl, name, value)).filter(Boolean);
            if (!entries.length) return;
            bindEl.nagiBound = true;

            const proxyData = getClosestProxy(bindEl);
            const props = Object.assign({}, ...entries.map((entry) => evaluate(`{${entry}}`, proxyData, proxyData, bindEl)));

            Object.entries(props).forEach(([key, val]) =>
                key.startsWith("@") ? listen(bindEl, key.slice(1), val, proxyData) : bindProp(bindEl, key, val),
            );

            dispatch(bindEl, "init", { bubbles: false });
        });
    };

    document.addEventListener("DOMContentLoaded", () => init(document.body));
})();
