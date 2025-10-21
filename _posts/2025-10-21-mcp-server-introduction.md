---
title: "MCP 서버란? Model Context Protocol 완벽 가이드"
date: 2025-10-21
author: botgymc
tags: [MCP, AI, Protocol, 개발도구, 튜토리얼]
---

# MCP 서버란 무엇인가?

Model Context Protocol(MCP)은 AI 모델이 외부 데이터 소스와 상호작용할 수 있도록 하는 표준화된 프로토콜입니다. 이 글에서는 MCP 서버의 개념부터 실제 구현까지 자세히 알아보겠습니다.

## MCP의 등장 배경

AI 모델은 훈련 데이터만으로는 실시간 정보나 특정 도메인 지식에 접근하기 어렵습니다. MCP는 이러한 한계를 극복하기 위해 만들어진 프로토콜로, AI 모델이:

- 📂 파일 시스템에 접근
- 🗄️ 데이터베이스 쿼리 실행
- 🌐 API 호출
- 🔧 개발 도구 사용

등을 표준화된 방식으로 수행할 수 있게 합니다.

## MCP의 핵심 개념

### 1. 서버-클라이언트 아키텍처

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│             │  MCP    │             │  Tool   │             │
│  AI Agent   │ ◄─────► │ MCP Server  │ ◄─────► │  Resources  │
│  (Client)   │         │             │         │  (Files,DB) │
└─────────────┘         └─────────────┘         └─────────────┘
```

- **클라이언트**: AI 에이전트나 애플리케이션
- **서버**: 도구와 리소스를 제공하는 MCP 서버
- **리소스**: 파일, 데이터베이스, API 등

### 2. 주요 구성 요소

#### Tools (도구)
AI가 호출할 수 있는 함수나 명령어입니다.

```typescript
{
  "name": "read_file",
  "description": "파일 내용을 읽습니다",
  "parameters": {
    "path": {
      "type": "string",
      "description": "읽을 파일의 경로"
    }
  }
}
```

#### Resources (리소스)
AI가 접근할 수 있는 데이터 소스입니다.

```typescript
{
  "uri": "file:///project/data.json",
  "name": "Project Data",
  "mimeType": "application/json"
}
```

#### Prompts (프롬프트)
재사용 가능한 프롬프트 템플릿입니다.

```typescript
{
  "name": "code_review",
  "description": "코드 리뷰를 위한 프롬프트",
  "arguments": ["file_path", "language"]
}
```

## MCP 서버 구현하기

### TypeScript로 MCP 서버 만들기

```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

// MCP 서버 생성
const server = new Server(
  {
    name: "my-mcp-server",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
      resources: {},
    },
  }
);

// 도구 목록 제공
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "calculate",
        description: "두 숫자를 더합니다",
        inputSchema: {
          type: "object",
          properties: {
            a: { type: "number" },
            b: { type: "number" },
          },
          required: ["a", "b"],
        },
      },
    ],
  };
});

// 도구 실행 핸들러
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  if (request.params.name === "calculate") {
    const { a, b } = request.params.arguments as { a: number; b: number };
    
    return {
      content: [
        {
          type: "text",
          text: `결과: ${a + b}`,
        },
      ],
    };
  }
  
  throw new Error(`알 수 없는 도구: ${request.params.name}`);
});

// 서버 시작
const transport = new StdioServerTransport();
await server.connect(transport);
```

### Python으로 MCP 서버 만들기

```python
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent

# 서버 초기화
app = Server("my-python-mcp-server")

# 도구 등록
@app.list_tools()
async def list_tools() -> list[Tool]:
    return [
        Tool(
            name="greet",
            description="사용자에게 인사합니다",
            inputSchema={
                "type": "object",
                "properties": {
                    "name": {"type": "string"}
                },
                "required": ["name"]
            }
        )
    ]

# 도구 실행
@app.call_tool()
async def call_tool(name: str, arguments: dict) -> list[TextContent]:
    if name == "greet":
        user_name = arguments.get("name", "Anonymous")
        return [
            TextContent(
                type="text",
                text=f"안녕하세요, {user_name}님!"
            )
        ]
    
    raise ValueError(f"알 수 없는 도구: {name}")

# 서버 실행
if __name__ == "__main__":
    stdio_server(app)
```

## MCP 서버 활용 사례

### 1. 파일 시스템 MCP 서버

```typescript
// 파일 읽기, 쓰기, 검색 기능 제공
const tools = [
  { name: "read_file", description: "파일 읽기" },
  { name: "write_file", description: "파일 쓰기" },
  { name: "search_files", description: "파일 검색" },
  { name: "list_directory", description: "디렉토리 목록" }
];
```

### 2. 데이터베이스 MCP 서버

```typescript
// SQL 쿼리 실행, 스키마 조회 등
const tools = [
  { name: "execute_query", description: "SQL 실행" },
  { name: "get_schema", description: "테이블 스키마 조회" },
  { name: "list_tables", description: "테이블 목록" }
];
```

### 3. API 통합 MCP 서버

```typescript
// 외부 API 호출을 MCP 도구로 래핑
const tools = [
  { name: "search_github", description: "GitHub 검색" },
  { name: "get_weather", description: "날씨 정보 조회" },
  { name: "translate_text", description: "텍스트 번역" }
];
```

## MCP 서버 배포하기

### 1. NPM 패키지로 배포

```bash
# package.json 설정
{
  "name": "my-mcp-server",
  "bin": {
    "my-mcp-server": "./dist/index.js"
  }
}

# 빌드 및 배포
npm run build
npm publish
```

### 2. VS Code Extension으로 배포

```json
// settings.json
{
  "mcp.servers": {
    "my-server": {
      "command": "node",
      "args": ["/path/to/server/index.js"]
    }
  }
}
```

### 3. Docker 컨테이너로 배포

```dockerfile
FROM node:20-alpine

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

CMD ["node", "dist/index.js"]
```

## MCP vs 기존 방식 비교

| 특징 | MCP | REST API | Function Calling |
|------|-----|----------|------------------|
| 표준화 | ✅ 통일된 프로토콜 | ❌ 각자 다른 규격 | ⚠️ 모델 종속적 |
| 타입 안전성 | ✅ 스키마 기반 | ⚠️ 문서 의존 | ✅ 스키마 기반 |
| 양방향 통신 | ✅ 지원 | ❌ 단방향 | ⚠️ 제한적 |
| 리소스 관리 | ✅ 내장 지원 | ❌ 별도 구현 필요 | ❌ 지원 안함 |

## 실전 예제: Git MCP 서버

```typescript
import { execSync } from "child_process";

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  switch (request.params.name) {
    case "git_status":
      const status = execSync("git status --short", { 
        encoding: "utf-8" 
      });
      return {
        content: [{ type: "text", text: status }]
      };
      
    case "git_log":
      const { limit = 10 } = request.params.arguments as any;
      const log = execSync(
        `git log --oneline -n ${limit}`,
        { encoding: "utf-8" }
      );
      return {
        content: [{ type: "text", text: log }]
      };
      
    case "git_diff":
      const diff = execSync("git diff", { encoding: "utf-8" });
      return {
        content: [{ type: "text", text: diff }]
      };
  }
});
```

## 보안 고려사항

### 1. 권한 관리

```typescript
// 허용된 경로만 접근 가능하도록 제한
const ALLOWED_PATHS = ["/home/user/projects"];

function validatePath(path: string): boolean {
  return ALLOWED_PATHS.some(allowed => 
    path.startsWith(allowed)
  );
}
```

### 2. 입력 검증

```typescript
// 사용자 입력 검증
function validateInput(input: unknown): asserts input is ValidInput {
  if (typeof input !== "object" || input === null) {
    throw new Error("Invalid input type");
  }
  
  // 추가 검증 로직...
}
```

### 3. 리소스 제한

```typescript
// 최대 파일 크기, 실행 시간 제한
const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
const MAX_EXECUTION_TIME = 30000; // 30초
```

## 디버깅 팁

### 1. 로깅 활성화

```typescript
import { ConsoleLogger } from "@modelcontextprotocol/sdk/shared/logger.js";

const server = new Server({
  name: "my-server",
  version: "1.0.0",
  logger: new ConsoleLogger()
});
```

### 2. 요청/응답 추적

```typescript
server.onrequest = (request) => {
  console.log("Request:", JSON.stringify(request, null, 2));
};

server.onresponse = (response) => {
  console.log("Response:", JSON.stringify(response, null, 2));
};
```

## 결론

MCP는 AI 에이전트와 외부 도구를 연결하는 강력한 프로토콜입니다. 주요 장점은:

✅ **표준화**: 일관된 인터페이스로 도구 통합  
✅ **확장성**: 새로운 도구를 쉽게 추가  
✅ **타입 안전성**: 스키마 기반 검증  
✅ **양방향 통신**: 실시간 상호작용 지원

MCP 서버를 직접 만들어보면서 AI 에이전트의 능력을 확장해보세요!

## 참고 자료

- [MCP 공식 문서](https://modelcontextprotocol.io/)
- [MCP SDK GitHub](https://github.com/modelcontextprotocol/typescript-sdk)
- [MCP 서버 예제 모음](https://github.com/modelcontextprotocol/servers)

---

**다음 글 예고**: MCP 서버와 Claude Desktop 통합하기 🚀
