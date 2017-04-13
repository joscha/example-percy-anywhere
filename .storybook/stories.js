const storybook = require('@kadira/storybook');
require('./config.js');

const stories = storybook.getStorybook();
console.log(JSON.stringify(stories, null, 2)); // eslint-disable-line no-console