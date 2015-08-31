@0xe2249d9ead63d718;

using Spk = import "/sandstorm/package.capnp";
# This imports:
#   $SANDSTORM_HOME/latest/usr/include/sandstorm/package.capnp
# Check out that file to see the full, documented package definition format.

const pkgdef :Spk.PackageDefinition = (
  # The package definition. Note that the spk tool looks specifically for the
  # "pkgdef" constant.

  id = "ap9cdcf994hy3wd5u0cuw50s7frugwz7qv0vzsduqqydrdknetf0",
  # Your app ID is actually its public key. The private key was placed in
  # your keyring. All updates must be signed with the same key.
  
  manifest = (
    # This manifest is included in your app package to tell Sandstorm
    # about your app.

    appTitle = (defaultText = "Game of Y"),
    appVersion = 1,  # Increment this for every release.
    appMarketingVersion = (defaultText = "0"),

    actions = [
      # Define your "new document" handlers here.
      ( title = (defaultText = "New Y Game"),
        command = .myCommand
        # The command to run when starting for the first time. (".myCommand"
        # is just a constant defined at the bottom of the file.)
      )
    ],

    continueCommand = .myCommand,
    # This is the command called to start your app back up after it has been
    # shut down for inactivity. Here we're using the same command as for
    # starting a new instance, but you could use different commands for each
    # case.

    metadata = (
      icons = (
        appGrid = (png = (dpi1x = embed "app-graphics/gameofy-128.png",
                          dpi2x = embed "app-graphics/gameofy-256.png")),
        grain = (png = (dpi1x = embed "app-graphics/gameofy-24.png",
                        dpi2x = embed "app-graphics/gameofy-48.png")),
        market = (png = (dpi1x = embed "app-graphics/gameofy-128.png",
                         dpi2x = embed "app-graphics/gameofy-256.png")),
      ),

      website = "http://y.hyperbotics.org/",
      codeUrl = "https://github.com/kentonv/y",
      license = (openSource = agpl3),
      categories = [games],

      author = (
        contactEmail = "kenton@sandstorm.io",
        pgpSignature = embed "pgp-signature",
        upstreamAuthor = "Hyperbotics",
      ),
      pgpKeyring = embed "pgp-keyring",

      description = (defaultText = embed "description.md"),
      shortDescription = (defaultText = "Board game"),

      screenshots = [
        (width = 448, height = 329, png = embed "app-graphics/screenshot.png")
      ]
    ),
  ),

  sourceMap = (
    # The following directories will be copied into your package.
    searchPath = [
      ( sourcePath = ".meteor-spk/deps" ),
      ( sourcePath = ".meteor-spk/bundle" )
    ]
  ),

  alwaysInclude = [ "." ]
  # This says that we always want to include all files from the source map.
  # (An alternative is to automatically detect dependencies by watching what
  # the app opens while running in dev mode. To see what that looks like,
  # run `spk init` without the -A option.)
);

const myCommand :Spk.Manifest.Command = (
  # Here we define the command used to start up your server.
  argv = ["/sandstorm-http-bridge", "4000", "--", "node", "start.js"],
  environ = [
    # Note that this defines the *entire* environment seen by your app.
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin")
  ]
);
