
const path = require('path');
const genDefaultConfig = require('@kadira/storybook/dist/server/config/defaults/webpack.config.js');

module.exports = function(config, env) {
  const myConfig = genDefaultConfig(config, env);

  // Extend it as you need.
  
  if (process.env.GENERATE_STORYBOOK_INDEX) {
    myConfig.entry.stories = [path.join(__dirname, './stories.js')];
    myConfig.output.filename = '[name].js';
  }

  return myConfig;
};