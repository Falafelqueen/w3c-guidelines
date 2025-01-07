const puppeteer = require("puppeteer");

/**
 * Extracts visible images from a given URL and logs their details.
 * @param {string} url - The URL to extract images from.
 */

async function extractVisibleImages(url) {
  let browser;
  try {
    browser = await puppeteer.launch();
    const page = await browser.newPage();

    await page.setUserAgent(
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    );
    await page.goto(url, { waitUntil: "networkidle0" });

    const images = await extractAndFilterImages(page);
    // const loadedImages = await filterLoadedImages(images, page);
    const imageDetails = await fetchImageDetails(images, page);

    console.log(JSON.stringify(imageDetails));
  } catch (error) {
    console.error("An error occurred during image extraction:", error.message);
  } finally {
    if (browser) {
      await browser.close();
    }
  }
}

async function extractAndFilterImages(page) {
  try {
    return await page.evaluate(() => {
      const imgSources = Array.from(
        document.querySelectorAll("img:not(picture img)")
      ).map((img) => img.src);

      const pictureSources = Array.from(
        document.querySelectorAll("picture source")
      ).map((source) => source.srcset);

      console.log("imgSources", imgSources);

      const bgImages = Array.from(document.querySelectorAll("*"))
        .map((el) => {
          const style = window.getComputedStyle(el);
          return style.backgroundImage.startsWith("url")
            ? style.backgroundImage.slice(5, -2)
            : null;
        })
        .filter((url) => url);
      return [...new Set([...imgSources, ...bgImages, ...pictureSources])];
    });
  } catch (error) {
    console.error("Failed to extract images from the page:", error);
    return []; // Return an empty array to handle gracefully in subsequent calls
  }
}

async function filterLoadedImages(images, page) {
  try {
    return Promise.all(
      images.map((src) =>
        page.evaluate((src) => {
          return new Promise((resolve) => {
            const img = new Image();
            img.src = src;
            img.onload = () =>
              resolve(img.width > 0 && img.height > 0 ? src : null);
            img.onerror = () => resolve(null);
          });
        }, src)
      )
    ).then((results) => results.filter((src) => src !== null));
  } catch (error) {
    console.error("Error filtering loaded images:", error);
    return []; // Return an empty array to handle gracefully
  }
}

async function fetchImageDetails(images, page) {
  console.error("Fetching image details...");
  console.log("images", images);
  // TODO: need to be able to handle images srcset and picture elements
  try {
    return Promise.all(
      images.map((src) =>
        console.log("Fetching details for:", src),
        page.evaluate(async (src) => {
          console.error("Fetching details for:", src);
          const response = await fetch(src);
          console.error("Response status:", response.status);
          const buffer = await response.arrayBuffer();
          return {
            url: src,
            size_kb: buffer.byteLength / 1024,
            size: buffer.byteLength / (1024 * 1024),
            format: response.headers.get("content-type"),
          };
        }, src)
      )
    );
  } catch (error) {
    console.error("Failed to fetch image details:", error);
    return []; // Return an empty array to ensure downstream processing does not fail
  }
}

const args = process.argv.slice(2); // Skip 'node' and the script path
const url = args[0];

extractVisibleImages(url);
