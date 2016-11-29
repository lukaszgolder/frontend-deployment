process.env.NODE_ENV = 'production';

var fs = require('fs-extra');
var chalk = require('chalk');
var webpack = require('webpack');
var config = require('../config/webpack.config.prod');
var paths = require('../config/paths');

function printErrors(summary, errors) {
  console.log(chalk.red(summary));
  console.log();
  errors.forEach(err => {
    console.log(err.message || err);
    console.log();
  });
}

function build() {
  webpack(config).run((err, stats) => {
    if (err) {
      printErrors('Failed to compile.', [err]);
      process.exit(1);
    }
  });
}

function copyPublicFolder() {
  fs.copySync(paths.appPublic, paths.appBuild, {
    dereference: true,
    filter: file => file !== paths.appHtml
  });
}

fs.emptyDirSync(paths.appBuild);
build();
copyPublicFolder();
