import { expect } from "chai";
import { App, mkApp } from "./app.js";
import { render } from "preact";

mocha.setup({ui: "bdd",
             slow: /* ms */ "200",
             timeout: '2000',
             checkLeaks: "true"
            });

// This library (like Mocha) is magically imported in the test index
const tl = globalThis.TestingLibraryDom
const txt = tl.getByText;
const qid = tl.queryByTestId;
const qar = tl.queryAllByRole;
const until = (f) => tl.waitFor(f, {interval: 10});

// clear all pouches
const clearDbs = async () => {
  const dbs = await window.indexedDB.databases()
  dbs.forEach(db => {
    if (db.name.startsWith("_pouch"))
      window.indexedDB.deleteDatabase(db.name)
  });
}
await clearDbs();
let __nextId = 2;

const newUserId = () =>  {
  return `user${__nextId++}`
}

/* In order to cleanly destroy (unmount) the Preact Component,
   we need to keep it in a global variable */
let APP = null;

const setupEach = (kont) => {
  APP = mkApp(newUserId(), document.createElement('div'));
  kont();
}

const teardownEach = (kont) => {
  if (APP) {
    render(null, APP);
    APP = null;
  }
  kont();
}

describe("Incrementing the current counter", () => {
  beforeEach(setupEach);
  afterEach(teardownEach);

  it("the starting value is 0", () => {
    expect(qid(APP, "counter").innerText).to.be.equal("0");
  });

  it("can be incremented", async () => {
    txt(APP, 'Increment').click()
    await until(() => expect(qid(APP, "counter").innerText).to.be.equal("1"));
  });

  it("can be decremented too", async () => {
    txt(APP, 'Increment').click();
    await until(() => expect(qid(APP, "counter").innerText).to.be.equal("1"));

    txt(APP, 'Decrement').click();
    await until(() => expect(qid(APP, "counter").innerText).to.be.equal("0"));
  });

});

describe("Persisting counter values", () => {
  beforeEach(setupEach);
  afterEach(teardownEach);

  it("can be done after incrementing", async () => {
    txt(APP, 'Increment').click()
    await until(() => expect(qid(APP, "counter").innerText).to.be.equal("1"));

    txt(APP, 'Save this counter').click()
    await until(() => expect(qid(APP, "counter-list").innerText).to.be.equal("1"));
  });

  it("new counter is started after saving the previous one", async () => {
    txt(APP, 'Increment').click()
    await until(() => expect(qid(APP, "counter").innerText).to.be.equal("1"));

    txt(APP, 'Save this counter').click()
    await until(() => expect(qid(APP, "counter").innerText).to.be.equal("0"));

    txt(APP, 'Decrement').click()
    await until(() => expect(qid(APP, "counter").innerText).to.be.equal("-1"))

    txt(APP, 'Save this counter').click()
    await until(() =>
      expect(qar(APP, "counter-list-item")
             .map((i) => i.innerText))
             .to.have.ordered.members(["-1", "1"]))
  });
});

