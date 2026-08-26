/**
 * 第五阶段测试云函数 api-test（最小可行性验证版）
 * - 仅返回结构化测试数据，不依赖任何数据库 SDK，确保可部署、可跨域调用
 * - 数据库读写验证将在后续步骤中通过懒加载 SDK 追加，保持本文件可独立运行
 * - 所有凭证通过 CloudBase 环境变量注入，代码内无明文
 */

// 统一 CORS 响应头（OPEN 鉴权下仍需函数自行返回，供静态站点 fetch 跨域）
const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET,POST,OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
  'Content-Type': 'application/json; charset=utf-8'
}

function json(body, statusCode = 200) {
  return { statusCode, headers: CORS, body: JSON.stringify(body) }
}

exports.main = async (event, context) => {
  const method = (event.httpMethod || 'GET').toUpperCase()
  // 预检请求直接放行
  if (method === 'OPTIONS') {
    return { statusCode: 204, headers: CORS, body: '' }
  }

  const query = event.queryString || {}
  const action = query.action || 'ping'

  if (action === 'ping') {
    return json({
      ok: true,
      msg: 'api-test alive',
      ts: Date.now(),
      env: process.env.TCB_ENV || 'unknown',
      runtime: process.version
    })
  }

  // 占位：数据库读写验证入口（后续步骤启用，暂不依赖 SDK）
  if (action === 'dbRead' || action === 'dbWrite') {
    return json({
      ok: false,
      action,
      pending: true,
      msg: '数据库读写验证尚未启用，等待第五阶段数据库步骤接入'
    })
  }

  return json({ ok: true, action, echo: query })
}
