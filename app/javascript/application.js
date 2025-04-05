// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
// import "./controllers"
import React from "react"
import { createRoot } from "react-dom/client"
import App from "./components/App.jsx"

document.addEventListener('DOMContentLoaded', () => {
  const rootElement = document.getElementById('root');
  if (rootElement) {
    const root = createRoot(rootElement);
    root.render(React.createElement(App));
  }
});
