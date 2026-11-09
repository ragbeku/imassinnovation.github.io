$ErrorActionPreference = 'Stop'
$root = (Resolve-Path $PSScriptRoot).Path
$port = 8765
$prefix = "http://127.0.0.1:$port/"
$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add($prefix)
try { $listener.Start() } catch { Write-Host "Could not start preview server on port $port. Close any other preview using that port." -ForegroundColor Red; Read-Host 'Press Enter to close'; exit 1 }
Write-Host "iMass Innovation preview is running at $prefix" -ForegroundColor Green
Write-Host 'Keep this window open while browsing. Press Ctrl+C to stop.'
Start-Process $prefix
$mime = @{ '.html'='text/html; charset=utf-8'; '.css'='text/css; charset=utf-8'; '.js'='application/javascript; charset=utf-8'; '.jpg'='image/jpeg'; '.jpeg'='image/jpeg'; '.png'='image/png'; '.webp'='image/webp'; '.svg'='image/svg+xml'; '.ico'='image/x-icon'; '.txt'='text/plain; charset=utf-8'; '.xml'='application/xml; charset=utf-8'; '.json'='application/json; charset=utf-8' }
try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    try {
      $urlPath = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
      if ([string]::IsNullOrWhiteSpace($urlPath)) { $urlPath = 'index.html' }
      $relative = $urlPath.Replace('/', [IO.Path]::DirectorySeparatorChar)
      $full = [IO.Path]::GetFullPath((Join-Path $root $relative))
      if (-not $full.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)) { throw 'Invalid path' }
      if (Test-Path -LiteralPath $full -PathType Container) { $full = Join-Path $full 'index.html' }
      if (-not (Test-Path -LiteralPath $full -PathType Leaf)) { $full = Join-Path $root '404.html'; $ctx.Response.StatusCode = 404 }
      $ext = [IO.Path]::GetExtension($full).ToLowerInvariant()
      if ($mime.ContainsKey($ext)) { $ctx.Response.ContentType = $mime[$ext] } else { $ctx.Response.ContentType = 'application/octet-stream' }
      $bytes = [IO.File]::ReadAllBytes($full)
      $ctx.Response.ContentLength64 = $bytes.Length
      $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } catch {
      $ctx.Response.StatusCode = 500
      $body = [Text.Encoding]::UTF8.GetBytes('Preview server error')
      $ctx.Response.OutputStream.Write($body, 0, $body.Length)
    } finally { $ctx.Response.OutputStream.Close() }
  }
} finally { $listener.Stop(); $listener.Close() }
