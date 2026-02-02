const crypto = require("crypto");
const admin = require("firebase-admin");
const { onRequest } = require("firebase-functions/v2/https");
const { setGlobalOptions } = require("firebase-functions/v2/options");
const logger = require("firebase-functions/logger");

const APP_PKG = "com.example.jiwa_bakti"; // <-- keep your package here

// Use a WORKING fallback right now (host it on Firebase Hosting).
// Later switch to Play once the listing is live:
// const FALLBACK_URL = `https://play.google.com/store/apps/details?id=${APP_PKG}`;
const FALLBACK_URL ="https://webnyou-flow-link-webnyou-jiwa-bakti-flowlinks.web.app/get-the-app";

setGlobalOptions({ region: "asia-southeast1", maxInstances: 10 });

admin.initializeApp();
const db = admin.firestore();

function genCode(len = 6) {
  return crypto
    .randomBytes(9)
    .toString("base64url")
    .replace(/[^A-Za-z0-9_-]/g, "")
    .slice(0, len);
}

function addCors(res) {
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  res.set("Access-Control-Allow-Headers", "Content-Type");
}

exports.createFlowLink = onRequest(async (req, res) => {
  addCors(res);
  if (req.method === "OPTIONS") return res.status(204).send("");

  try {
    if (req.method !== "POST")
      return res.status(405).json({ error: "Method Not Allowed" });

    const { link, type, id, meta } = req.body || {};
    if (!link || typeof link !== "string")
      return res.status(400).json({ error: "Missing 'link'" });

    let code;
    for (;;) {
      code = genCode(6);
      const exists = (await db.collection("flowlinks").doc(code).get()).exists;
      if (!exists) break;
    }

    await db.collection("flowlinks").doc(code).set({
      link,
      type: type ?? null,
      id: id ?? null,
      meta: meta ?? null,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    const prefix =
      "https://webnyou-flow-link-webnyou-jiwa-bakti-flowlinks.web.app";
    res.json({ shortLink: `${prefix}/${code}` });
  } catch (e) {
    logger.error(e);
    res.status(500).json({ error: "Internal error" });
  }
});

exports.resolveFlowLink = onRequest(async (req, res) => {
  addCors(res);
  if (req.method === "OPTIONS") return res.status(204).send("");

  try {
    const parts = req.path.split("/").filter(Boolean);
    const code = parts.pop();
    if (!code) return res.status(400).json({ error: "Missing code" });

    const snap = await db.collection("flowlinks").doc(code).get();
    if (!snap.exists) return res.status(404).json({ error: "Not found" });

    res.json(snap.data());
  } catch (e) {
    logger.error(e);
    res.status(500).json({ error: "Internal error" });
  }
});

// HTML trampoline so Android actually opens the app (or falls back)
exports.openShort = onRequest(async (req, res) => {
  try {
    const code = (req.path || "").replace(/^\/+/, "").split("/")[0];
    if (!code) return res.status(404).send("Link not found");

    const snap = await db.collection("flowlinks").doc(code).get();
    if (!snap.exists) return res.status(404).send("Link not found");
    const data = snap.data() || {};
    const landingParams = new URLSearchParams({ code });
    if (data.type != null) landingParams.set("type", String(data.type));
    const landingUrl = `/get-the-app?${landingParams.toString()}`;

    const ua = (req.get("user-agent") || "");
const isAndroid = /Android/i.test(ua);
const isWindows = /Windows/i.test(ua);
const isIOS = /iPhone|iPad|iPod/i.test(ua);

if (isWindows) {
  // Windows → help page
  return res.redirect(302, FALLBACK_URL); // this is /get-the-app on your hosting
}

if (isAndroid) {
  // Android → landing page with a button (no auto-intent!)
  return res.redirect(302, `/get-the-app?code=${encodeURIComponent(code)}`);
}

if (isIOS) {
  // iOS - use the same landing page to open the custom scheme
  return res.redirect(302, landingUrl);
}
// Others → resolved web URL (or help page)
return res.redirect(302, data.link || FALLBACK_URL);}catch (e) {
    logger.error(e);
    res.status(500).send("Internal error");
  }
});

