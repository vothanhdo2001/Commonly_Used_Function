# Kiến Trúc Project Automation Profiles UI

## Cây Thư Mục

```
automation-profiles-ui/
├── cypress/
│   ├── e2e/
│   │   ├── features/
│   │   │   └── authentication.feature      # Định nghĩa test cases bằng Gherkin syntax (Given-When-Then). Mô tả các scenario test bằng ngôn ngữ tự nhiên, dễ đọc và hiểu cho cả technical và non-technical team members
│   │   └── step-definitions/
│   │       └── authentication.ts           # Map các bước trong Gherkin thành code thực thi. Mỗi step definition sẽ gọi Page Objects hoặc API Clients để thực hiện các hành động cụ thể
│   └── support/
│       ├── page-objects/
│       │   └── login-page.ts               # Định nghĩa UI elements (selectors) và các actions có thể thực hiện trên mỗi trang. Giúp tách biệt logic test với UI selectors, dễ maintain khi UI thay đổi
│       ├── api-clients/
│       │   ├── api-client.ts               # Base class xử lý OAuth2 authentication và HTTP requests (GET/POST/PUT/DELETE). Tự động refresh token khi hết hạn
│       │   └── profile-api.ts              # Client cụ thể cho Profile API, cung cấp các methods để gọi API liên quan đến profiles, preferences, notification contacts
│       ├── models/
│       │   └── profile-api.ts              # Định nghĩa TypeScript types/interfaces cho tất cả data structures. Đảm bảo type safety trong toàn bộ codebase, giúp IDE autocomplete và catch errors tại compile time
│       ├── helpers/
│       │   └── general.ts                  # Chứa các utility functions tái sử dụng như getIdFromHref, isStringNullOrEmpty, generatePhoneNumber, normalizeText, etc. Giúp code DRY (Don't Repeat Yourself)
│       ├── constants/
│       │   └── general.ts                  # Định nghĩa các constants như labels, roles, homepage types. Tránh hardcode values trong code, dễ thay đổi và maintain
│       └── commands.ts                     # Định nghĩa custom Cypress commands như cy.dataId(), cy.print(). Mở rộng functionality của Cypress để phù hợp với project
├── infrastructure/
│   └── lib/
│       └── ApplicationStack.ts            # Sử dụng AWS CDK để quản lý configurations. Lưu trữ configs (baseUrl, API credentials, user credentials) vào AWS Systems Manager Parameter Store cho các environments khác nhau (prod, uat, silo5)
├── config/
│   └── local.json                          # Chứa environment configuration cho local development. Bao gồm baseUrl, API credentials, và user credentials cho các roles khác nhau
└── cypress.config.ts                      # File cấu hình chính của Cypress: viewport, timeouts, preprocessor, reporter, environment settings
```

