const puppeteer = require("puppeteer");

async function extractVisibleImages(url) {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto(url, { waitUntil: "networkidle0" });

  const images = await page.evaluate(() => {
    const imgElements = Array.from(document.querySelectorAll("img")).map(
      (img) => img.src
    );

    // Collect background images from computed styles of all elements
    const bgImages = Array.from(document.querySelectorAll("*"))
      .map((el) => {
        const style = window.getComputedStyle(el);
        if (style.backgroundImage !== "none") {
          // Extract URLs from the background-image property
          return style.backgroundImage.replace(/url\((['"]?)(.*?)\1\)/g, "$2");
        }
      })
      .filter((url) => url);

    return [...new Set([...imgElements, ...bgImages])]; // Remove duplicates and combine both arrays
  });

  // Further filter to ensure images are visible and loaded
  const loadedImages = await Promise.all(
    images.map((src) =>
      page.evaluate((src) => {
        return new Promise((resolve) => {
          const img = new Image();
          img.src = src;
          img.onload = () => {
            // Ensure the image is loaded and has dimensions
            resolve(img.width > 0 && img.height > 0 ? src : null);
          };
          img.onerror = () => resolve(null);
        });
      }, src)
    )
  );

  console.log(loadedImages.filter((src) => src !== null)); // Filter out nulls and log results
  await browser.close();
}

// Capture command line arguments
const args = process.argv.slice(2); // First two elements are 'node' and the script path
const url = args[0];
// Default to checking all elements if no selector is provided

extractVisibleImages(url);
