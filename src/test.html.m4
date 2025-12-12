<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <script src="https://unpkg.com/@testing-library/dom@10.4.1/dist/@testing-library/dom.umd.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/dequal@2.0.3/dist/index.min.js "></script>
    <script src="/pouchdb.min.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/mocha/mocha.css">
    <script type="importmap">m4_include(`importmap-test.json')</script>
  </head>
  <body>
    <h1><a href="/">BACK TO APP</a></h1>
    <div id="mocha"></div>
    <script src="https://unpkg.com/mocha/mocha.js"></script>
    <script class="mocha-init"> mocha.setup({ui: "bdd", slow: /* ms */ "200", timeout: '2000', checkLeaks: "true"})</script>
    <script type="module" src="/test.js?v=M4_BUSTER"></script>
    <script type="module" class="mocha-exec">mocha.run();</script>
  </body>
</html>
