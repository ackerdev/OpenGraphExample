# OpenGraphExample

An example application utilizing Facebook's [OpenGraph protocol](https://ogp.me/) to display rich media for a given link.

## How It Works

The application is built on the Phoenix framework. The main page of the application utilizes Phoenix.LiveView to provide a real-time interactive frontend experience for users. While I chose not to take advantage of the socket and pubsub functionality due to the simple nature of the project, it would be trivial to enhance the project and enable synchronized updates across multiple clients via LiveView.

The main user interaction on this page is the form input, which accepts a URL of the user's choice to fetch the OpenGraph data from. Due to the simplistic nature of the application, I chose to rely solely on browser validation for the URL input and used a simple form component. However, if more robust validation was required, I would instead utilize the standard form object backed by an Ecto.Changeset which could perform more specific validation.

When the form is submitted, an event is observed by the LiveView process that fires off an asynchronous Task under a Supervisor which is responsible for fetching the remote url. This allows the application to continue while the process runs in the background, and is supervised to ensure that these processes can be appropriately managed, potentially restarted, and their results observed. This approach is simple enough for the expected scale of this example, but in order to support higher scale the obvious limitation is the singular supervisor acting as a bottleneck; a PartitionSupervisor could instead be utilized to distribute the workers amongst multiple supervisors. If this was not sufficient, then a queue system could be utilized to accumulate jobs which could then be processed for example in a GenStage pipeline or an Oban job processor.

The process for fetching the remote url utilizes the [req](https://hex.pm/packages/req) package to make the HTTP request and the [floki](https://hex.pm/packages/floki) package, included in phoenix's test environment by default, to parse the resulting HTML. Currently, the application only concerns itself with the 4 required properties: title, image, url, and type. Additionally, it assumes that there is only one value for the image field. These fields are mapped onto a schema that is then stored in Postgres with Ecto. If I were to expand this application to further support the OpenGraph standard fields, changes would have to be made both to the parsing and the schema, particularly around how to handle multiple image fields as well as subfields such as `og:image:height`.

The progress of these tasks is displayed to the user via a placeholder with a spinning loader animation that is removed when the task completes. The url is only stored temporarily in the LiveView state, rather than persisted to the database, in an attempt to maintain simplicity; should a process fail, the only cleanup required is to remove the url entry from the state. If I were to make this application more robust, I might consider persisting the record of entry and processing state though what solution for that persistence may vary based on other factors; in a simplistic case I might consider Erlang Term Storage as an in-memory solution or Redis for a disk-backed equivalent; postgres could be utilized especially in the case of Oban; perhaps introspection on the queue, if one exists, could even be used to power this display.

The OpenGraph schema is utilized to validate the collected metadata. If successful, the placeholder is removed from the processing list and the entry is added to the completed OpenGraph entries, which are displayed as a clickable card with the image and title of the link displayed. This is currently not replicated across all active users, but could easily be enhanced via the use of the LiveView socket and pubsub mechanics to broadcast the completed tasks to all active sockets.

The application code is well tested, though the LiveView code is minimally tested. More robust testing around the LiveView functionality would be desirable but was omitted for time constraints and instead simplistic tests that for example prove successful rendering are in place to provide a base level confidence.

Thank you for reading :)

## Requirements

This application requires a Postgres database. See the `config/dev.exs` file to adjust connection settings for your local environment.

## Starting the Application

To start the application:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.