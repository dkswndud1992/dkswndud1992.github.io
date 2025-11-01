---
title: "MCP 서버와 Claude Desktop 통합하기 - 실전 가이드"
date: 2025-10-28
author: botgymc
tags: [MCP, Claude, Desktop, AI, 통합, 튜토리얼]
---

# MCP 서버와 Claude Desktop 통합하기

이전 글에서 MCP(Model Context Protocol) 서버의 개념과 구현 방법을 알아보았습니다. 이번에는 실제로 MCP 서버를 Claude Desktop 앱과 통합하여 Claude의 능력을 확장하는 방법을 단계별로 살펴보겠습니다.

## 시작하기 전에

### 필요한 것들

- ✅ Claude Desktop 앱 (최신 버전)
- ✅ Node.js 18 이상 또는 Python 3.10 이상
- ✅ 기본적인 터미널 사용 지식
- ✅ 텍스트 에디터 (VS Code 권장)

### Claude Desktop이란?

Claude Desktop은 Anthropic의 Claude AI를 데스크톱 애플리케이션으로 사용할 수 있게 해주는 앱입니다. MCP 프로토콜을 지원하여 로컬 MCP 서버와 통합할 수 있습니다.

## Claude Desktop 설치 및 설정

### 1. Claude Desktop 다운로드

```bash
# macOS
brew install --cask claude

# Windows
# https://claude.ai/download 에서 다운로드
```

### 2. Claude Desktop 설정 파일 위치

Claude Desktop은 MCP 서버 설정을 JSON 파일로 관리합니다:

**macOS:**
```bash
~/Library/Application Support/Claude/claude_desktop_config.json
```

**Linux:**
```bash
~/.config/claude/claude_desktop_config.json
```

**Windows:**
```bash
%APPDATA%\Claude\claude_desktop_config.json
```

## 첫 번째 MCP 서버 통합하기

### 간단한 계산기 MCP 서버 만들기

먼저 간단한 계산기 MCP 서버를 만들어봅시다.

#### TypeScript 버전

**1. 프로젝트 초기화**

```bash
mkdir mcp-calculator-server
cd mcp-calculator-server
npm init -y
npm install @modelcontextprotocol/sdk
npm install -D typescript @types/node
```

**2. TypeScript 설정 (tsconfig.json)**

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "Node16",
    "moduleResolution": "Node16",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true
  }
}
```

**3. 서버 구현 (src/index.ts)**

```typescript
#!/usr/bin/env node
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

const server = new Server(
  {
    name: "calculator-server",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// 사용 가능한 도구 목록
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "add",
        description: "두 숫자를 더합니다",
        inputSchema: {
          type: "object",
          properties: {
            a: { type: "number", description: "첫 번째 숫자" },
            b: { type: "number", description: "두 번째 숫자" },
          },
          required: ["a", "b"],
        },
      },
      {
        name: "multiply",
        description: "두 숫자를 곱합니다",
        inputSchema: {
          type: "object",
          properties: {
            a: { type: "number", description: "첫 번째 숫자" },
            b: { type: "number", description: "두 번째 숫자" },
          },
          required: ["a", "b"],
        },
      },
      {
        name: "power",
        description: "거듭제곱을 계산합니다 (a의 b승)",
        inputSchema: {
          type: "object",
          properties: {
            base: { type: "number", description: "밑" },
            exponent: { type: "number", description: "지수" },
          },
          required: ["base", "exponent"],
        },
      },
    ],
  };
});

// 도구 실행
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    if (name === "add") {
      const { a, b } = args as { a: number; b: number };
      const result = a + b;
      return {
        content: [
          {
            type: "text",
            text: `${a} + ${b} = ${result}`,
          },
        ],
      };
    } else if (name === "multiply") {
      const { a, b } = args as { a: number; b: number };
      const result = a * b;
      return {
        content: [
          {
            type: "text",
            text: `${a} × ${b} = ${result}`,
          },
        ],
      };
    } else if (name === "power") {
      const { base, exponent } = args as { base: number; exponent: number };
      const result = Math.pow(base, exponent);
      return {
        content: [
          {
            type: "text",
            text: `${base}^${exponent} = ${result}`,
          },
        ],
      };
    }

    throw new Error(`알 수 없는 도구: ${name}`);
  } catch (error) {
    return {
      content: [
        {
          type: "text",
          text: `오류 발생: ${error instanceof Error ? error.message : String(error)}`,
        },
      ],
      isError: true,
    };
  }
});

// 서버 시작
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("Calculator MCP Server 시작됨");
}

main().catch((error) => {
  console.error("서버 시작 실패:", error);
  process.exit(1);
});
```

**4. package.json 설정**

```json
{
  "name": "mcp-calculator-server",
  "version": "1.0.0",
  "type": "module",
  "bin": {
    "mcp-calculator-server": "./dist/index.js"
  },
  "scripts": {
    "build": "tsc",
    "prepare": "npm run build"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^0.5.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0"
  }
}
```

**5. 빌드**

```bash
npm run build
```

### Claude Desktop에 MCP 서버 등록하기

이제 만든 MCP 서버를 Claude Desktop에 등록합니다.

**claude_desktop_config.json 편집:**

```json
{
  "mcpServers": {
    "calculator": {
      "command": "node",
      "args": [
        "/absolute/path/to/mcp-calculator-server/dist/index.js"
      ]
    }
  }
}
```

> 💡 **중요**: 경로는 반드시 절대 경로를 사용해야 합니다!

**macOS/Linux 예시:**
```json
{
  "mcpServers": {
    "calculator": {
      "command": "node",
      "args": [
        "/Users/username/projects/mcp-calculator-server/dist/index.js"
      ]
    }
  }
}
```

**Windows 예시:**
```json
{
  "mcpServers": {
    "calculator": {
      "command": "node",
      "args": [
        "C:\\Users\\username\\projects\\mcp-calculator-server\\dist\\index.js"
      ]
    }
  }
}
```

### Claude Desktop 재시작 및 테스트

1. **Claude Desktop 완전히 종료**
   - macOS: Cmd + Q
   - Windows: 작업 관리자에서 프로세스 종료

2. **Claude Desktop 재시작**

3. **MCP 서버 연결 확인**
   - Claude Desktop 하단에 🔌 아이콘이 표시되는지 확인
   - 도구 목록에서 calculator 서버의 도구들이 보이는지 확인

4. **테스트해보기**

Claude에게 다음과 같이 요청해보세요:

```
25와 17을 더해줘
```

```
12의 3승을 계산해줘
```

Claude가 MCP 서버의 도구를 사용하여 계산을 수행합니다!

## 실전 예제: 파일 시스템 MCP 서버

더 유용한 예제로 파일 시스템 접근 MCP 서버를 만들어봅시다.

### Python으로 구현하기

**1. 프로젝트 설정**

```bash
mkdir mcp-filesystem-server
cd mcp-filesystem-server
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install mcp
```

**2. 서버 구현 (server.py)**

```python
#!/usr/bin/env python3
import os
import json
from pathlib import Path
from typing import Any
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent

# 허용된 디렉토리 설정 (보안을 위해 - 환경 변수로도 설정 가능)
ALLOWED_DIRECTORY = os.environ.get("MCP_ALLOWED_DIR", str(Path.home() / "Documents"))

app = Server("filesystem-server")

@app.list_tools()
async def list_tools() -> list[Tool]:
    return [
        Tool(
            name="read_file",
            description="파일 내용을 읽습니다",
            inputSchema={
                "type": "object",
                "properties": {
                    "path": {
                        "type": "string",
                        "description": "읽을 파일의 경로"
                    }
                },
                "required": ["path"]
            }
        ),
        Tool(
            name="list_directory",
            description="디렉토리의 파일 목록을 가져옵니다",
            inputSchema={
                "type": "object",
                "properties": {
                    "path": {
                        "type": "string",
                        "description": "목록을 가져올 디렉토리 경로"
                    }
                },
                "required": ["path"]
            }
        ),
        Tool(
            name="write_file",
            description="파일에 내용을 씁니다",
            inputSchema={
                "type": "object",
                "properties": {
                    "path": {
                        "type": "string",
                        "description": "쓸 파일의 경로"
                    },
                    "content": {
                        "type": "string",
                        "description": "파일에 쓸 내용"
                    }
                },
                "required": ["path", "content"]
            }
        ),
    ]

def is_path_allowed(path: str) -> bool:
    """경로가 허용된 디렉토리 내에 있는지 확인"""
    abs_path = os.path.abspath(path)
    return abs_path.startswith(ALLOWED_DIRECTORY)

@app.call_tool()
async def call_tool(name: str, arguments: Any) -> list[TextContent]:
    try:
        if name == "read_file":
            path = arguments["path"]
            
            if not is_path_allowed(path):
                return [TextContent(
                    type="text",
                    text=f"오류: 접근이 허용되지 않은 경로입니다. {ALLOWED_DIRECTORY} 내의 파일만 접근 가능합니다."
                )]
            
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            return [TextContent(
                type="text",
                text=f"파일 내용:\n\n{content}"
            )]
        
        elif name == "list_directory":
            path = arguments["path"]
            
            if not is_path_allowed(path):
                return [TextContent(
                    type="text",
                    text=f"오류: 접근이 허용되지 않은 경로입니다."
                )]
            
            items = os.listdir(path)
            items_list = "\n".join([f"- {item}" for item in sorted(items)])
            
            return [TextContent(
                type="text",
                text=f"디렉토리 내용:\n\n{items_list}"
            )]
        
        elif name == "write_file":
            path = arguments["path"]
            content = arguments["content"]
            
            if not is_path_allowed(path):
                return [TextContent(
                    type="text",
                    text=f"오류: 접근이 허용되지 않은 경로입니다."
                )]
            
            with open(path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            return [TextContent(
                type="text",
                text=f"파일 작성 완료: {path}"
            )]
        
        return [TextContent(
            type="text",
            text=f"알 수 없는 도구: {name}"
        )]
    
    except Exception as e:
        return [TextContent(
            type="text",
            text=f"오류 발생: {str(e)}"
        )]

if __name__ == "__main__":
    stdio_server(app)
```

**3. Claude Desktop 설정**

```json
{
  "mcpServers": {
    "calculator": {
      "command": "node",
      "args": [
        "/path/to/mcp-calculator-server/dist/index.js"
      ]
    },
    "filesystem": {
      "command": "python",
      "args": [
        "/path/to/mcp-filesystem-server/server.py"
      ],
      "env": {
        "PYTHONPATH": "/path/to/mcp-filesystem-server"
      }
    }
  }
}
```

## 고급 설정 및 팁

### 환경 변수 사용하기

MCP 서버에 환경 변수를 전달할 수 있습니다:

```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["./server.js"],
      "env": {
        "API_KEY": "your-api-key",
        "DEBUG": "true",
        "MAX_RETRIES": "3"
      }
    }
  }
}
```

### NPM 패키지로 설치된 MCP 서버 사용하기

```bash
# 전역 설치
npm install -g @modelcontextprotocol/server-github

# Claude Desktop 설정
```

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github"
      ],
      "env": {
        "GITHUB_TOKEN": "your-github-token"
      }
    }
  }
}
```

### 여러 MCP 서버 동시 사용하기

Claude Desktop은 여러 MCP 서버를 동시에 사용할 수 있습니다:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "python",
      "args": ["/path/to/filesystem-server.py"]
    },
    "database": {
      "command": "node",
      "args": ["/path/to/database-server.js"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_xxxxx"
      }
    },
    "calculator": {
      "command": "node",
      "args": ["/path/to/calculator-server.js"]
    }
  }
}
```

## 트러블슈팅

### MCP 서버가 연결되지 않을 때

**1. 로그 확인하기**

Claude Desktop의 개발자 도구를 열어 로그를 확인합니다:

- **macOS**: View → Toggle Developer Tools
- **Windows**: Ctrl + Shift + I

**2. 경로 확인**

```bash
# 절대 경로가 맞는지 확인
which node  # /usr/local/bin/node
which python  # /usr/bin/python3
```

**3. 권한 확인**

```bash
# 스크립트에 실행 권한 부여
chmod +x /path/to/server.js
chmod +x /path/to/server.py
```

**4. 수동으로 서버 테스트**

```bash
# 서버가 정상 작동하는지 확인
node /path/to/server.js
python /path/to/server.py
```

### 일반적인 오류 해결

#### "Cannot find module" 오류

```bash
# 의존성 재설치
cd /path/to/server
npm install
```

#### Python 가상환경 오류

Claude Desktop 설정에서 가상환경의 Python을 직접 지정:

```json
{
  "mcpServers": {
    "my-python-server": {
      "command": "/path/to/venv/bin/python",
      "args": ["/path/to/server.py"]
    }
  }
}
```

#### 서버가 응답하지 않음

타임아웃 설정 추가 (밀리초 단위):

```json
{
  "mcpServers": {
    "slow-server": {
      "command": "node",
      "args": ["./server.js"],
      "timeout": 30000
    }
  }
}
```

> 💡 **참고**: timeout 값은 밀리초 단위입니다. 30000 = 30초

## 보안 고려사항

### 1. 경로 제한

```typescript
const ALLOWED_PATHS = [
  path.join(os.homedir(), 'Documents'),
  path.join(os.homedir(), 'Projects')
];

function isPathAllowed(requestedPath: string): boolean {
  const absolute = path.resolve(requestedPath);
  return ALLOWED_PATHS.some(allowed => 
    absolute.startsWith(allowed)
  );
}
```

### 2. 입력 검증

```typescript
function validateInput(input: unknown): asserts input is ValidInput {
  if (typeof input !== 'object' || input === null) {
    throw new Error('Invalid input');
  }
  
  // 추가 검증...
}
```

### 3. 민감한 정보 보호

```typescript
// 환경 변수에서 API 키 읽기
const API_KEY = process.env.API_KEY;
if (!API_KEY) {
  throw new Error('API_KEY 환경 변수가 필요합니다');
}
```

## 실전 활용 사례

### 1. 개발 워크플로우 자동화

```
Claude에게 요청:
"현재 프로젝트의 TODO 주석을 찾아서 정리해줘"
```

MCP 서버가 파일 시스템을 검색하고 TODO를 찾아 정리합니다.

### 2. 코드 리뷰 자동화

```
Claude에게 요청:
"최근 변경된 파일들을 리뷰해줘"
```

Git MCP 서버가 변경사항을 가져오고 Claude가 리뷰합니다.

### 3. 데이터 분석

```
Claude에게 요청:
"database의 users 테이블에서 최근 가입자 통계를 분석해줘"
```

Database MCP 서버가 쿼리를 실행하고 Claude가 분석합니다.

## MCP 서버 디버깅

### 로깅 추가하기

```typescript
import { ConsoleLogger } from "@modelcontextprotocol/sdk/shared/logger.js";

const server = new Server(
  {
    name: "my-server",
    version: "1.0.0",
    logger: new ConsoleLogger()
  },
  {
    capabilities: { tools: {} }
  }
);
```

### 요청/응답 로깅

```typescript
server.onerror = (error) => {
  console.error("[MCP Error]", error);
};

server.onclose = () => {
  console.log("[MCP] Connection closed");
};
```

## 커뮤니티 MCP 서버

이미 만들어진 유용한 MCP 서버들:

### 공식 MCP 서버

```bash
# GitHub 통합
npm install -g @modelcontextprotocol/server-github

# Slack 통합
npm install -g @modelcontextprotocol/server-slack

# Google Drive 통합
npm install -g @modelcontextprotocol/server-gdrive
```

### 설정 예시

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "your_token"
      }
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_TOKEN": "your_token"
      }
    }
  }
}
```

## 성능 최적화

### 1. 캐싱 구현

```typescript
const cache = new Map<string, { data: any; timestamp: number }>();
const CACHE_TTL = 60000; // 1분

function getCached(key: string) {
  const cached = cache.get(key);
  if (cached && Date.now() - cached.timestamp < CACHE_TTL) {
    return cached.data;
  }
  return null;
}
```

### 2. 비동기 처리

```typescript
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  // 병렬 처리
  const results = await Promise.all([
    fetchData1(),
    fetchData2(),
    fetchData3()
  ]);
  
  return { content: [{ type: "text", text: JSON.stringify(results) }] };
});
```

### 3. 리소스 제한

```typescript
const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
const MAX_RESULTS = 100;

if (fileSize > MAX_FILE_SIZE) {
  throw new Error('File too large');
}
```

## 결론

MCP 서버를 Claude Desktop과 통합하면:

✅ **로컬 리소스 접근**: 파일, 데이터베이스, API 등  
✅ **워크플로우 자동화**: 반복 작업을 Claude가 처리  
✅ **커스텀 도구**: 필요한 기능을 직접 구현  
✅ **보안성**: 로컬에서 실행되어 데이터 안전

이제 여러분만의 MCP 서버를 만들어 Claude Desktop의 능력을 확장해보세요!

## 다음 단계

- 🔧 복잡한 워크플로우를 위한 MCP 서버 체인 구성
- 🔐 OAuth와 인증을 사용하는 MCP 서버 구축
- 📊 실시간 데이터 처리를 위한 스트리밍 MCP 서버
- 🌐 웹 서비스로 MCP 서버 배포하기

## 참고 자료

- [MCP 공식 문서](https://modelcontextprotocol.io/)
- [Claude Desktop 다운로드](https://claude.ai/download)
- [MCP SDK GitHub](https://github.com/modelcontextprotocol/typescript-sdk)
- [MCP Python SDK](https://github.com/modelcontextprotocol/python-sdk)
- [커뮤니티 MCP 서버 모음](https://github.com/modelcontextprotocol/servers)

---

**이전 글**: [MCP 서버란? Model Context Protocol 완벽 가이드](/posts/2025-10-21-mcp-server-introduction)
