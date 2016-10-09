/* eslint-disable no-var */
'use strict';

var path = require('path');
var GlobalConfig = require('../config/webpack.common.config');

// must match config.webpack.dev_server.port
var devServerPort = 3808;

// set TARGETNODE_ENV=production on the environment to add asset fingerprints
var production = process.env.RAILS_ENV === 'production' || process.env.NODE_ENV === 'production';
var bindOn = process.env.BIND || '127.0.0.1';

var config = {
  entry: {
    // Sources are expected to live in $app_root/webpack
    'bundle': './webpack/assets/javascripts/bundle.js'
  },

  output: {
    // Build assets directly in to public/webpack/, let webpack know
    // that all webpacked assets start with webpack/

    // must match config.webpack.output_dir
    path: path.join(__dirname, '..', 'public', 'webpack'),
    publicPath: '/webpack/',

    filename: GlobalConfig.production ? '[name]-[chunkhash].js' : '[name].js'
  }

};

config = Object.assign(GlobalConfig, config);

if (config.production) {
  config.plugins.push(
    new webpack.NoErrorsPlugin(),
    new webpack.optimize.UglifyJsPlugin({
      compressor: { warnings: false },
      sourceMap: false
    }),
    new webpack.DefinePlugin({
      'process.env': { NODE_ENV: JSON.stringify('production') }
    }),
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.OccurenceOrderPlugin()
  );
} else {
  require('dotenv').config();

  config.devServer = {
    host: process.env.BIND || '127.0.0.1',
    port: devServerPort,
    headers: { 'Access-Control-Allow-Origin': '*' }
  };
  // Source maps
  config.devtool = 'inline-source-map';
}

module.exports = config;
