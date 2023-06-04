# AI Code Review Extension

The AI RevU Code Extension provides integration with the Claude AI API for performing code interactions with your code directly from Visual Studio Code.

## Features

- Code review entire projects
- Let you interact with your code directly from Visual

## Requirements

To use this extension, you need to have the following:

- Visual Studio Code installed on your machine
- An active internet connection to communicate with the AI API

## Usage

1. Execute command AI Code Review: Current Project
2. The code will be sent to the Claude AI API for review.
3. The code review response will be displayed in a webview panel.

## Extension Settings

This extension does not have any configurable settings.

## Known Issues

There are no known issues at the moment. If you encounter any problems, please report them on the [GitHub repository](https://github.com/tnramalho/vscode-ext-ai-code-review).

## Release Notes

### 0.0.1

Initial release of the Claude AI Code Review Extension.

## Contributing

Contributions are welcome! If you find any bugs, have feature requests, or want to contribute to the project, please follow the guidelines in the [CONTRIBUTING.md](./CONTRIBUTING.md) file.

## License

This extension is released under the [MIT License](./LICENSE.md).

## To test
 npm run compile
 open src/extension.ts then press f5 to open a new vscode with extension loaded.

 AI Code Review : to run code review for selected text
 AI Code Review: Current Document : to run code review for current document
