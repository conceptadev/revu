import * as fs from "fs";

import * as path from "path";
import * as vscode from "vscode";
import { WebviewPanel } from "vscode";

interface ResourcePaths {
  htmlPath: string;
  styleCss: string;
  interopJs: string;
  flutterJs: string;
  basePath: string;
  codePayload: string;
}

export function activate(context: vscode.ExtensionContext) {
  let submitProjectDisposable = vscode.commands.registerCommand(
    "claude-ai-code-review.codeReviewProject",
    () => {
      const workspaceFolders = vscode.workspace.workspaceFolders;
      if (workspaceFolders) {
        const code = getCodeFromProject(workspaceFolders[0].uri.fsPath);
        showCodeReviewResponse(code, context);
      }
    }
  );

  context.subscriptions.push(submitProjectDisposable);
}

function getCodeFromProject(projectPath: string): string {
  let code = "";

  const processFile = (filePath: string) => {
    const fileExtension = path.extname(filePath);
    if (
      fileExtension === ".tsx" ||
      fileExtension === ".js" ||
      fileExtension === ".jsx" ||
      fileExtension === ".ts"
    ) {
      const fileContent = fs.readFileSync(filePath, "utf8");

      code += `# file path: ${filePath}\n` + fileContent + "\n\n";
    }
  };

  const processFolder = (folderPath: string) => {
    console.log("folderPath", folderPath);
    const files = fs.readdirSync(folderPath);
    for (const file of files) {
      const filePath = path.join(folderPath, file);
      const fileStats = fs.statSync(filePath);

      if (fileStats.isDirectory()) {
        processFolder(filePath);
      } else {
        processFile(filePath);
      }
    }
  };

  processFolder(path.join(projectPath, "src"));

  return code;
}

function showCodeReviewResponse(
  code: string,
  context: vscode.ExtensionContext
) {
  const panel = vscode.window.createWebviewPanel(
    "codeReviewPanel",
    "Code Review Response",
    vscode.ViewColumn.Beside,
    {
      enableScripts: true,
      localResourceRoots: [vscode.Uri.file(path.join(__dirname, ".."))],
      retainContextWhenHidden: true,
    }
  );

  // Load the HTML content for the webview
  panel.webview.html = getWebviewContent(code, context, panel);

  setTimeout(() => {
    panel.webview.postMessage(code);
  }, 7000);
}

function getWebviewContent(
  code: string,
  context: vscode.ExtensionContext,
  panel: WebviewPanel
) {
  const { webview } = panel;

  const htmlPathUri = vscode.Uri.file(
    path.join(context.extensionPath, "src", "index.html")
  );
  const htmlPath = htmlPathUri.with({ scheme: "vscode-resource" });

  let basePathUri = vscode.Uri.file(
    context.asAbsolutePath(path.join("src", "web"))
  );

  const basePath = webview.asWebviewUri(basePathUri).toString();

  let interopJsPathUri = vscode.Uri.file(
    context.asAbsolutePath(path.join("src", "web", "js", "js-interop.js"))
  );
  const interopJsPath = webview.asWebviewUri(interopJsPathUri).toString();

  let flutterJsPathUri = vscode.Uri.file(
    context.asAbsolutePath(path.join("src", "web", "flutter.js"))
  );
  const flutterJsPath = webview.asWebviewUri(flutterJsPathUri).toString();

  let styleCssPathUri = vscode.Uri.file(
    context.asAbsolutePath(path.join("src", "web", "css", "style.css"))
  );
  const styleCssPath = webview.asWebviewUri(styleCssPathUri).toString();

  const resourcePaths: ResourcePaths = {
    htmlPath: htmlPath.fsPath,
    styleCss: styleCssPath.toString(),
    interopJs: interopJsPath.toString(),
    flutterJs: flutterJsPath.toString(),
    basePath: basePath.toString(),
    codePayload: code,
  };

  return _renderWebviewContent(resourcePaths);
}

function _renderWebviewContent(paths: ResourcePaths) {
  console.log(`Loading webview content from ${paths.htmlPath}`);

  const html = fs.readFileSync(paths.htmlPath, "utf8");
  const variables = {
    paths,
  };

  const webviewHtml = new Function(
    "variables",
    `with (variables) { return \`${html}\`; }`
  )(variables);

  return webviewHtml;
}
