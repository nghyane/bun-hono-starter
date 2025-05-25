# Pre-commit Hooks Setup

Dự án này đã được thiết lập với pre-commit hooks để tự động format code trước khi commit.

## Cấu hình hiện tại

### Tools được sử dụng:
- **Husky**: Quản lý Git hooks
- **lint-staged**: Chỉ format các file đã staged
- **Prettier**: Code formatter

### Cấu hình Prettier (`.prettierrc`):
```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "bracketSpacing": true,
  "arrowParens": "avoid",
  "endOfLine": "lf"
}
```

### Files được format tự động:
- `*.{js,jsx,ts,tsx,json}`: JavaScript/TypeScript files
- `*.{css,scss,md}`: Styling và Markdown files

## Cách hoạt động

1. Khi bạn chạy `git commit`, pre-commit hook sẽ tự động chạy
2. `lint-staged` sẽ format tất cả các file đã staged
3. Nếu có thay đổi, các file sẽ được add lại vào staging area
4. Commit sẽ được thực hiện với code đã được format

## Scripts có sẵn

```bash
# Format toàn bộ project
bun run format

# Kiểm tra format (không thay đổi file)
bun run format:check

# Lint và fix code
bun run lint
```

## Troubleshooting

### Nếu pre-commit hook không hoạt động:
```bash
# Đảm bảo husky được cài đặt
bun run prepare

# Kiểm tra quyền thực thi
chmod +x .husky/pre-commit
```

### Nếu muốn skip pre-commit hook (không khuyến khích):
```bash
git commit -m "message" --no-verify
```

## Lợi ích

- ✅ Code luôn được format nhất quán
- ✅ Giảm conflicts do format khác nhau
- ✅ Tự động hóa quy trình format
- ✅ Đảm bảo code quality trước khi commit
