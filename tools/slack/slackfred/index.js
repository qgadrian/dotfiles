const { WebClient, ErrorCode } = require('@slack/web-api');

const token = process.env.SLACK_TOKEN;

const web = new WebClient(token);

const isBlank = (expiration) => expiration === "" || expiration === undefined;

const daysToMillis = (days) => days * 24 * 60 * 60;

const process_expiration_timestamp = (expirationIsInDays) => {
  const custom_expiration = process.env.status_expiration;

  if (expirationIsInDays === 'true') {
    // in seconds, defaults to 1 day expressed as milliseconds
    const default_expiration = daysToMillis(1);

    const expiration_timestamp = isBlank(custom_expiration) ?
      default_expiration : daysToMillis(custom_expiration);

    const relative_status_expiration = Date.now() / 1000 + expiration_timestamp;

    console.log("Set holidays status!");

    return relative_status_expiration;
  } else {
    // in seconds, defaults to 1 hour expressed as milliseconds
    const default_expiration = 3600;

    const expiration_timestamp = isBlank(custom_expiration) ?
      default_expiration : custom_expiration * 60;

    const relative_status_expiration = Date.now() / 1000 + expiration_timestamp;

    const status_expiration = custom_expiration == 0 ? custom_expiration : relative_status_expiration;

    return status_expiration;
  }
}

// https://api.slack.com/methods/users.profile.set
(async () => {
  const status_text = process.env.status_text;
  const status_emoji = process.env.status_emoji;
  // in seconds, defaults to 1 hour express as milliseconds
  // const default_expiration = 3600;
  //
  // const custom_expiration = process.env.status_expiration;
  //
  // const expiration_timestamp = custom_expiration === "" || custom_expiration === undefined ?
  //   default_expiration : custom_expiration * 60;
  //
  // const relative_status_expiration = Date.now() / 1000 + expiration_timestamp;
  //
  // const status_expiration = custom_expiration === 0 ? custom_expiration : relative_status_expiration;

  const status_expiration = process_expiration_timestamp(process.env.expiration_is_in_days);

  if (status_text === "set_away_status") {
    await web.users.setPresence({
      presence: "away"
    });
    console.log("Successfully set presence to away");
  } else if (status_text === "set_active_status") {
    await web.users.setPresence({
      presence: "auto"
    });
    console.log("Successfully set presence to active");
  } else {
    try {
      if (process.env.message) {
        await web.chat.postMessage({
          channel: process.env.channel,
          text: process.env.message
        });
      } else {
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
  }
})();
