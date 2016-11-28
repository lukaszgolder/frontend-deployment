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
