var ExtractTextPlugin = require("extract-text-webpack-plugin");
var path              = require("path");

var node_modules_dir = path.join(__dirname, "node_modules");

module.exports = {
  entry: {
    app: [
      "./source/assets/stylesheets/app.sass",
      "./source/assets/javascripts/app.js"
    ]
  },

  resolve: {
    root: path.join(__dirname, "source", "assets", "javascripts"),
    fallback: [node_modules_dir],
    alias: {
      jquery: "jquery/src/jquery",
      jQuery: "jquery/src/jquery"
    }
  },

  resolveLoader: {
    root: node_modules_dir,
    fallback: [node_modules_dir]
  },

  output: {
    path: path.join(__dirname, ".tmp", "dist"),
    filename: "assets/javascripts/[name].js"
  },

  module: {
    loaders: [{
      test: /.*\.js$/,
      loader: 'babel',
      exclude: /node_modules/,
      query: {
        presets: ['es2015', 'react'],
        plugins: ['transform-runtime']
      }
    }, {
      test: /.+\.(sass|scss)$/,
      loader: ExtractTextPlugin.extract(
        "style",
        "css!resolve-url!sass?sourceMap&includePaths[]=" + node_modules_dir
      )
    }, {
      test: /.+\.(svg|ttf|otf|eot|ttf|woff|woff2)/,
      loader: 'url',
      query: {
        limit: '10000'
      }
    }]
  },

  plugins: [
    // When CSS is encountered, add it to `assets/stylesheets/app.css`, instead
    // of inlining it in the Javascript.
    new ExtractTextPlugin("assets/stylesheets/app.css")
  ]
};
// For production.
// new webpack.DefinePlugin({
//   "process.env": {
//     NODE_ENV: JSON.stringify("production")
//   }
// }
