# Maestro Mobile Testing

[![Validate](https://github.com/mustafaautomation/maestro-mobile-testing/actions/workflows/ci.yml/badge.svg)](https://github.com/mustafaautomation/maestro-mobile-testing/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Maestro](https://img.shields.io/badge/Maestro-Mobile%20Testing-6C3483.svg)](https://maestro.mobile.dev)

Modern mobile E2E testing with [Maestro](https://maestro.mobile.dev) — YAML-based flows, no code compilation, supports Android + iOS + Flutter + React Native.

---

## Why Maestro?

| Feature | Maestro | Appium |
|---------|---------|--------|
| Setup | `curl` install, no SDK | Java SDK + drivers + server |
| Test format | YAML (human-readable) | Java/Python code |
| Speed | Fast (no WebDriver protocol) | Slow (HTTP bridge) |
| Flakiness | Built-in retry + tolerance | Manual waits needed |
| Flutter/RN | Native support | Requires bridges |

---

## Flows

| Flow | Category | Tags |
|------|----------|------|
| Login | Auth | smoke |
| Invalid Login | Auth | regression |
| Logout | Auth | regression |
| Browse Products | Products | smoke |
| Product Detail | Products | regression |
| Add to Cart | Cart | regression |
| Remove from Cart | Cart | regression |
| **Total: 7** | | |

---

## Quick Start

```bash
# Install Maestro
curl -Ls "https://get.maestro.mobile.dev" | bash

# Run all flows
maestro test flows/

# Run specific category
maestro test flows/auth/

# Run by tag
maestro test --include-tags smoke flows/
```

---

## Flow Example

```yaml
appId: com.saucelabs.mydemoapp
tags:
  - smoke
  - auth
---
- launchApp
- tapOn: "Menu"
- tapOn: "Log In"
- tapOn:
    id: "nameET"
- inputText: "bod@example.com"
- tapOn:
    id: "passwordET"
- inputText: "10203040"
- tapOn: "LOGIN"
- assertVisible: "PRODUCTS"
```

No page objects. No imports. No compilation. Just YAML.

---

## CI Integration

```yaml
- name: Run Maestro tests
  uses: mobile-dev-inc/action-maestro-cloud@v1
  with:
    api-key: ${{ secrets.MAESTRO_CLOUD_API_KEY }}
    app-file: app.apk
    flows: flows/
```

---

## Project Structure

```
maestro-mobile-testing/
├── flows/
│   ├── auth/
│   │   ├── login.yaml             # Valid login
│   │   ├── login-invalid.yaml     # Error message on bad credentials
│   │   └── logout.yaml            # Login → verify → logout
│   ├── products/
│   │   ├── browse-products.yaml   # Product catalog visible
│   │   └── product-detail.yaml    # Tap product → detail → back
│   └── cart/
│       ├── add-to-cart.yaml       # Add product → verify in cart
│       └── remove-from-cart.yaml  # Add → remove → verify empty
└── .github/workflows/ci.yml       # YAML syntax validation
```

---

## Maestro vs Appium — When to Use

| Use Case | Choose |
|----------|--------|
| Quick mobile smoke tests | **Maestro** |
| Complex gesture sequences | Appium |
| Flutter / React Native apps | **Maestro** |
| Cross-platform (same tests) | **Maestro** |
| Custom Java/Python logic | Appium |
| CI cloud execution | **Maestro Cloud** |

---

## License

MIT

---

Built by [Quvantic](https://quvantic.com)
