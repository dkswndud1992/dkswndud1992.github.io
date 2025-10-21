# Jekyll 로컬 서버 실행 스크립트

Write-Host "Jekyll 로컬 서버 시작..." -ForegroundColor Green

# Ruby 설치 확인
try {
    $rubyVersion = ruby --version 2>$null
    if ($rubyVersion) {
        Write-Host "Ruby가 설치되어 있습니다: $rubyVersion" -ForegroundColor Cyan
        
        # Bundler 확인
        $bundlerVersion = bundle --version 2>$null
        if (-not $bundlerVersion) {
            Write-Host "Bundler 설치 중..." -ForegroundColor Yellow
            gem install bundler
        }
        
        # 의존성 설치
        Write-Host "의존성 설치 중..." -ForegroundColor Yellow
        bundle install
        
        # Jekyll 서버 실행
        Write-Host "Jekyll 서버를 시작합니다..." -ForegroundColor Green
        Write-Host "사이트 주소: http://localhost:4000" -ForegroundColor Cyan
        bundle exec jekyll serve --livereload
    }
} catch {
    Write-Host "Ruby가 설치되어 있지 않습니다." -ForegroundColor Red
    
    # Docker 확인
    try {
        $dockerVersion = docker --version 2>$null
        if ($dockerVersion) {
            Write-Host "Docker가 설치되어 있습니다: $dockerVersion" -ForegroundColor Cyan
            Write-Host "Docker로 Jekyll 서버를 시작합니다..." -ForegroundColor Green
            
            if (Test-Path "docker-compose.yml") {
                Write-Host "docker-compose.yml 사용" -ForegroundColor Yellow
                docker-compose up
            } else {
                Write-Host "Docker 컨테이너 직접 실행" -ForegroundColor Yellow
                docker run --rm -it `
                    -p 4000:4000 -p 35729:35729 `
                    -v ${PWD}:/srv/jekyll `
                    jekyll/jekyll:latest `
                    jekyll serve --livereload
            }
        }
    } catch {
        Write-Host "Docker도 설치되어 있지 않습니다." -ForegroundColor Red
        Write-Host ""
        Write-Host "다음 중 하나를 설치해주세요:" -ForegroundColor Yellow
        Write-Host "1. Ruby: https://rubyinstaller.org/downloads/" -ForegroundColor White
        Write-Host "2. Docker Desktop: https://www.docker.com/products/docker-desktop" -ForegroundColor White
        Write-Host ""
        Write-Host "또는 LOCAL_TESTING.md 파일을 참고하세요." -ForegroundColor Cyan
    }
}
