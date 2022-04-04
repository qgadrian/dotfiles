const { WebClient, ErrorCode } = require('@slack/web-api');

const token = process.env.SLACK_TOKEN;

const web = new WebClient(token);

// https://api.slack.com/methods/users.profile.set
(async () => {
  const status_text = process.env.status_text;
  const status_emoji = process.env.status_emoji;
  // in seconds, defaults to 1 hour express as milliseconds
  const default_expiration = 3600;

  const expiration_timestamp = process.env.status_expiration === "" || process.env.status_expiration === undefined ?
    default_expiration : process.env.status_expiration * 60;

  const status_expiration = Date.now() / 1000 + expiration_timestamp

  try {
    // Post a message to the channel, and await the result.
    // Find more arguments and details of the response: https://api.slack.com/methods/chat.postMessage
    await web.users.profile.set({
      profile: {
        status_text: status_text,
        status_emoji: status_emoji,
        status_expiration: status_expiration
      }
    });

    if (status_text === "" && status_emoji === "") {
      console.log("Successfully cleared status");
    } else {
      console.log(`Successfully changed status to ${status_text} ${status_emoji}`);
    }
  } catch (error) {
    // Check the code property, and when its a PlatformError, log the whole response.
    if (error?.code === ErrorCode.PlatformError) {
      console.log(error.data);
    } else {
      // Some other error, oh no!
      console.log(`Well, that was unexpected: ${error}`);
    }
  }
})();

