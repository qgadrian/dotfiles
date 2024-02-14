module.exports = {
  defaultBrowser: "Firefox",
  rewrite: [
    // {
    // Redirect all urls to use https
    // match: ({ url }) => url.protocol === "http",
    // url: { protocol: "https" }
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
    }
  ],
  options: {
    hideIcon: true,
  }
};
