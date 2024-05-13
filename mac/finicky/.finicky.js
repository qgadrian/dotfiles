// Documentation: https://github.com/johnste/finicky/wiki/Configuration
module.exports = {
  defaultBrowser: "Firefox",
  rewrite: [
    {
      // Append notion:// to all notion.so urls
      match: /notion.so.*pvs.*/,
      url: ({ url }) => ({ ...url, protocol: "notion" })
    },
    // Rewrite Slack URLs to open in the Slack app
    // Example:
    // slack://channel?team=T9HEVULAW&id=CCRQY0W8J&thread_ts=p1708514465810739
    // {
    //   match: /slack.com\/archives/,
    //   url: ({ url }) => {
    //     const channelId = url.pathname.split("/")[2];
    //     return {
    //       ...url,
    //       protocol: "slack",
    //       host: "channel",
    //       pathname: channelId
    //     };
    //   }
    // },
    // {
    //   // Append notion:// to all notion.so urls
    //   match: /notion.so\/mysite\/.*/,
    //   url: ({ url }) => ({ ...url, protocol: "notion" })
    // }
  ],
  handlers: [
    {
      // Open apple.com urls in Safari
      match: finicky.matchHostnames(["apple.com"]),
      browser: "Safari"
    },
    // {
    //   // Open any url that includes the string "workplace" in Firefox
    //   match: /workplace/,
    //   browser: "Firefox"
    // },
    {
      // Open meet.google.com urls in Google Chrome
      match: [
        "*meet.google.com/*",
      ],
      browser: "Google Chrome"
    },
    {
      // Open notion:// urls in Notion
      match: /notion:/,
      browser: "Notion"
    },
  ],
  options: {
    hideIcon: true,
  }
};
