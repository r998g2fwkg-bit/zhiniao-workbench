-- 批量导入话术和演示数据

-- ====================
-- 导入话术 (RAW_DATA)
-- ====================
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0001', '在你身边', '向顾客推荐店内服务', '「值享焕新」年年用新机（202303）', 1, 0, '主动推荐
你发现顾客比较担心手机使用中会损坏，你觉得是推荐 「值享焕新」的好机会...', '我推荐您考虑一下值享焕新服务。不仅有两年官方延保，还可以每年差不多半价换新手机。这样您平时用着省心，换新机时又划算。', '值享焕新/两年官方延保', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0002', '在你身边', '向顾客推荐店内服务', '「值享焕新」年年用新机（202303）', 2, 1, '你具体说说这个值享焕新都有哪些好处?', '您买新款 iPhone 时，加购 AppleCare+两年官方延保，就相当于参加了“值享焕新”。延保包括两年内不限次数的意外损坏保修，而且维修费用很便宜，这样您就不用担心手机摔坏之类的了。另外，您买后的第 3 个月到第 13个月末期间换新机时，可以按照原来的半价回收，比如您现在买 iPhone 14 Pro 256G 价格是 8,899 元，将来回收价就是 4450 元，非常划算。同时还有机会返还 AppleCare+ 延保余额。这样既有使用保障，又享受换新优惠，非常合适的。', '两年官方延保/不限次/意外损坏保修/半价回收/延保余额', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0003', '在你身边', '向顾客推荐店内服务', '「以旧换新」聪明不浪费
（202603）', 1, 0, '场景～当顾客对新品感兴趣时，你可以主动推荐「以旧换新」服务，帮助顾客轻松升级，促进成交。
请根据你所在门店实际情况回答（左右滑动提示了解不同答案）', 'A.我们店里有以旧换新活动，相当于补个差价就可以换购新产品了。你如果手里有闲置的iPhone或者安卓手机直接就能在机器上回收，当场到账。关键您可以跨品类以旧换新，相当于换购新iPhone、 iPad、 Apple Watch或者Mac都可以，还可以享受10%换新补贴，特别合适。
B.我们店里有以旧换新活动，相当于补个差价就可以换购新产品了。像闲置的iPhone、 iPad、 Apple Watch或者Mac，甚至安卓手机都能直接在机器上回收，当场到账。关键您可以跨品类以旧换新，相当于不管您回收的是什么产品，新款iPhone、 iPad、 Apple Watch或者Mac都可以换购，还可以享受10%换新补贴，特别合适。', '以旧换新/当场到账/跨品类/换新补贴', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0004', '在你身边', '向顾客推荐店内服务', '「以旧换新」聪明不浪费
（202603）', 2, 1, '我对 MacBook Neo 挺感兴趣的，有个闲置手机想拿过来置换，但是今天没带，怎么办？', '没关系，您今天可以购买，把新品带回家。然后只要七天内把新、旧设备一起带过来，一样可以当场回收并获得10%换新补贴。而且我们是正规的回收商负责回收，数据安全和隐私都有保障，您可以放心。', '7/当场回收/换新补贴/正规/数据安全/隐私', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0005', '在你身边', '向顾客推荐店内服务', '「分期付款」不添压力添新机（202402）', 1, 0, '推荐分期付款
你察觉顾客对产品很满意，但是因为价格的问题，有些犹豫，你觉得应该推荐分期付款..', '现在在我们这里买非常合适，我们店里可以以旧换新，还可以分期付款，每个月几百块就可以用新手机。', '以旧换新/分期付款', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0006', '在你身边', '向顾客推荐店内服务', '「分期付款」不添压力添新机（202402）', 2, 1, '你们这都有什么分期啊?能分几期？', '目前支持花呗、支付宝信用卡、京东白条、银联分期、可以分 3、6、12 期，其中花呗和银联最长支持 24 期。', '花呗/京东白条/银联/支付宝信用卡', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0007', '在你身边', '向顾客推荐店内服务', '「分期付款」不添压力添新机（202402）', 3, 1, '只能全额分期吗?能帮我查一下具体的吗?', '全额，部分和组合分期都可以。我帮您具体查一下。', '全额/部分/组合', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0008', '在你身边', '向顾客推荐店内服务', '「数据迁移」专业又放心（202303）', 1, 0, '在你们这买手机，旧手机数据都能导过去吗?', '没问题，我们可以帮您做数据迁移，旧手机的全部资料，比如通讯录、照片、信息、设置这些都能导到新手机上。', '数据迁移', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0009', '在你身边', '向顾客推荐店内服务', '「数据迁移」专业又放心（202303）', 2, 1, '你们会有人帮我导手机数据的对吧?', '是的，我们会来协助您的。数据会从旧手机直接传输到新手机上，数据安全和隐私这块，您可以放心。', '协助/数据安全/隐私/放心', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0010', '在你身边', '向顾客推荐店内服务', '1:1协助有问题，学技巧，随时随地（202402）', 1, 0, '我要是回去有哪里不会用的，能回来找你们么?', '当然可以，我们店里有专业的 MyCoach 私教，是我们的售后产品服务专家，可以随时随地帮您。', '私教/产品服务专家', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0011', '在你身边', '向顾客推荐店内服务', '1:1协助有问题，学技巧，随时随地（202402）', 2, 1, '你说的这个私教是什么意思，具体给我介绍一下?', '在我们店里，有 Apple 认证的产品服务专家提供从数据迁移到日常使用的问题答疑。我们还提供1对1私教课程和定期的主题公开课教您一些使用技巧，欢迎您随时回来。', 'Apple认证/产品服务专家/数据迁移/答疑/私教/公开课', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0012', '在你身边', '向顾客推荐店内服务', '1:1协助有问题，学技巧，随时随地（202402）', 3, 1, '你们门店还有这样的服务啊？挺好的，我怎么跟他们联系呢？', '您遇到 Apple 产品的任何问题，欢迎随时随地来店或通过小程序、企业微信联系，我们随时随地为您提供专业解答和支持。', '任何问题/小程序/企业微信/随时随地', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0013', '在你身边', '向顾客推荐店内服务', '1:1协助有问题，学技巧，随时随地（202402）', 4, 1, '你刚才说还教使用技巧，都包括什么？', '内容非常丰富，比较受欢迎的有「新朋友快速上手」「职场人士必学神器」等等。通过私教课程和公开课，MyCoach 私教会帮您更好的使用Apple产品。', '私教课程/公开课', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0014', '在你身边', '向顾客推荐店内服务', '1:1协助有问题，学技巧，随时随地（202402）', 5, 1, '我看经常有很多人围在一起学 iPhone 摄影什么的，你们店里有吗?
周末一小时/少儿夏令营&冬令营
请根据你所在的门店实际情况回答(左右滑动提示可以看到不同答案)', 'a) 有的，我们有「周末一小时」，是免费公开课。包括摄影、绘画、音乐、编程、提升效率这些主题，你周末有空可以来听听看啊。如果您家里有 6-12 岁的小朋友，还可以关注一下我们寒暑假开设的少儿夏令营和冬令营。都是定制的非常好的课程，比如画画、编程、音乐这些主题，不仅免费，也不需要自带设备，能学到东西还能获得特别的纪念品。 
b) 我们店目前没有，但您可以从小程序上查到附近有活动的门店，线上预约。', '周末一小时/免费/公开课/夏令营/冬令营', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0015', '在你身边', '向顾客推荐店内服务', '「售后服务」离店服务不掉线（202303）', 1, 0, '如果产品有问题，你们能修吗？', '可以的，我们有专业的售后服务。您在使用过程中遇到任何问题，都可以来找我们。', '售后服务', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0016', '在你身边', '向顾客推荐店内服务', '「售后服务」离店服务不掉线（202303）', 2, 1, '你们店都包括哪些售后服务呢?
店内售后服务请根据你所在门店实际情况回答(左右滑动提示了解不同答案)', 'a) 我们可以做故障诊断、系统升级。
如果有硬件故障，我们提供官方授权维修，维修使用的都是正品零部件，您可以放心。另外，如果您有操作使用方面的疑问，我们也可以帮您解决。', '故障诊断/系统升级', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0017', '在你身边', '向顾客推荐店内服务', '「售后服务」离店服务不掉线（202303）', 3, 1, '', 'b) 我们可以做故障诊断、系统升级。
如果有硬件故障，我们可以接机送修，帮您把机器送到官方授权维修的门店。另外，如果您有操作使用方面的疑问，我们也可以帮您解决。', '接机送修', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0018', '在你身边', '向顾客推荐店内服务', '向购机顾客介绍“三包”政策(202305)', 1, 0, '这个 iPhone 我是买来送朋友的，如果拆封发现有问题，是不是可以回来换?', '我们是 Apple 授权专营店。您在我们这里买完全可以放心。根据国家三包法规定，如出现硬件引起的功能性故障，自购买之日起 7 天内可退、换货或维修;15 天内，可换货或维修。对于软件问题，我们也可以立即解决。', '授权专营店/三包法/7/天内/15/天内/软件问题', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0019', '在你身边', '向顾客推荐店内服务', '向购机顾客介绍“三包”政策(202305)', 2, 1, '场景：接下来，你可以主动向顾客推荐店内的服务，比如:数据迁移和一对一私教', '如果您的朋友需要将旧手机的数据迁移到新手机，我们有免费的数据迁移服务。如果使用过程中遇到问题，我们有专业的私教，他们是产品专家，可以提供一对一的服务。', '数据迁移/私教', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0020', '在你身边', '向顾客推荐店内服务', '「企业微信」全套服务在你身边（202303）', 1, 0, '主动推荐
顾客进店体验产品或询问信息后，你可以邀请顾客添加企业微信，保持联络。
平时使用手机遇到问题我该怎么办?', '您可以加一下我们的企业微信，之后有任何问题，随时联系我们就行。店里有活动或者有新品都可以在我们的朋友圈看到。', '企业微信', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0021', '在你身边', '向顾客推荐店内服务', 'Apple 授权专营店在你身边（202402）', 1, 0, '你们这是官方的苹果店吗？', '是的，我们是 Apple 授权专营店，就在你的身边，所以您可以就近到店购买，也可以在线购买，小时送达。
我们卖的产品都是 Apple 官方直供的，尽管放心。', '授权专营店/在线购买/小时送达', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0022', '在你身边', '向顾客推荐店内服务', 'Apple 授权专营店在你身边（202402）', 2, 1, '那像售后服务什么的，你们都有吗？', '是的，我们提供由 Apple 支持的专业服务。售前售后服务都有的。比如在店里购买新设备时，可以以旧换新，直接折抵一部分钱；
付款时也可以选择多种分期方式；买了新设备以后，我们有专人帮您做数据迁移；
另外，您在使用产品过程中遇到任何问题，我们可以提供1对1协助；如果是设备出现问题，我们也能提供专业的售后诊断。
您对哪个服务感兴趣，我给你详细介绍一下？', '数据迁移/以旧换新/分期/私教/售后诊断', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0023', '在你身边', '向顾客推荐店内服务', 'Apple 授权专营店在你身边（202402）', 3, 1, '那还不错，我暂时没有问题。', '您可以加我们的企业微信，有任何问题，随时联系我们。', '企业微信', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0024', '在你身边', '向顾客推荐店内服务', '向顾客推荐国补优惠（202503）', 1, 0, '场景
在和顾客的对话中, 你希望主动推荐国补优 惠, 从而获得销售机会', '现在买 Mac电脑和售价在6000元及以下的iPhone, iPad,Apple Watch, 都可以享受国补优惠。Mac 最高补2000元, 其他最高补 500 元, 而且国补还可以和店里的其他优惠政策叠加。现在购买非常合适,  错过就没有了。', '6000/国补优惠/2000/叠加', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0025', '在你身边', '向顾客推荐店内服务', '向顾客推荐国补优惠（202503）', 2, 1, '享受国补操作麻烦吗？有什么限制吗？', '不麻烦, 我可以协助您在手机上操作, 10 分钟左右就可以搞定。 
不过, 要和您说明一下： 首先国补优惠券必须本人申请和使用, 并且每人每类产品只能享受一 次。 另外, 在购买新机后, 需要现场拆封激活, 并且只能开具个人发票。', '10/本人/激活/个人发票', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0026', '在你身边', '向顾客推荐店内服务', '维修周期（202510）', 1, 0, '大概要多久才能修好我的手机？', '您好, 我们门店是官方授权接机点, 需要将设备寄送到指定的维修中心进行处理。具体维修周期会因故障复杂程度和备件情况有所浮动。一般来说从寄出到返回大约需要7到15个工作日。设备送修期间也请您保持手机畅通, 当维修进度更新时, 我们会通过短信通知您, 您也可以通过微信（维修）小程序查询维修进度。', '官方授权/维修中心/7到15个工作日/维修进度/短信/维修小程序', '2020-01-01', 'archived');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0027', '在你身边', '向顾客推荐店内服务', '推荐顾客加入 “在你身边VIP” 会员（202506）', 1, 0, '顾客在结账时，你可以主动推荐在你身边VIP会员', '推荐您加入我们的“在你身边VIP”会员计划能给您带来更多实惠和贴心服务，今天注册会员后，您将立即获得1000积分，完善资料还能再拿200积分，之后每消费1元就能累计1积分买的越多，积分越多，这些积分可以立即兑换App Store卡、产品代金券，也可以加钱换购无线充电器等热门配件非常划算！
  除此之外我们会员还能享受全天候在线客服支持，免费不限次数的一对一到店私教课程，以及到店的免费检测，我们还会不定期推出会员专属服务。', '', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0028', '在你身边', '向顾客推荐店内服务', '推荐顾客加入 “在你身边VIP” 会员（202506）', 2, 1, '这是这家门店的会员吗？', '现在推出的“在你身边VIP”是Apple授权专营店会员，目前全国1000多家门店都参加，不仅在线下购买，可以积分，在京东到家、美团、饿了么、抖音、淘宝、高德等线上平台购买也可以积分，非常方便！', '', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0029', '在你身边', '向顾客推荐店内服务', '推荐顾客加入 “在你身边VIP” 会员（202506）', 3, 1, '~哦！那线上平台的订单怎么积分？', '线上平台订单需要在您下单后的14天内，在Apple授权专营店商城小程序-会员中心的自助积分中，上传订单截图，系统识别，订单签收后7天后，对应的积分就生效了！', '', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0030', '在你身边', '向顾客推荐店内服务', '推荐顾客加入 “在你身边VIP” 会员（202506）', 4, 1, '线下购买的积分也需要七天后才生效吗？', '线下购买获得的积分是即刻生效的，您加入会员付款后，就可以在会员中心看到生效的积分了。', '', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0031', '在你身边', '向顾客推荐店内服务', '推荐顾客加入 “在你身边VIP” 会员（202506）', 5, 1, '那咱们的积分有有效期吗？', '“在你身边VIP”积分，从获得积分开始一直到第2年的12月31日才失效，比如您今天累计的积分，到2026年12月31日才失效。这期间都可以关注积分商城，换购您需要的产品。积分商城还会不定期上新！', '', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0032', '在你身边', '向顾客推荐店内服务', '推荐顾客加入 “在你身边VIP” 会员（202506）', 6, 1, '那还挺方便的，那我今天加一个会员吧！', '好的，您扫码就能加入！', '', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0033', '在你身边', 'AppleCare', 'AppleCare
当客户不认可检测结果时', 1, 0, '我的电池就是不好用, 每天一到下午就要再次充电, 为什么你们检测说没有问题呢？必须给我换一块新的。', '电池用得快, 确实会影响日常使用。我们的检测主要看的是电池本身是否存在异常, 从结果来看, 您的电池很健康, 这至少说明目前并不是电池老化或故障导致的问题。像您提到的这种使用感受, 很多时候还会和运行的应用、屏幕亮度、网络环境或者后台活动有关。在当前检测结果正常的情况下, 系统这边暂时不支持更换电池, 但我可以帮您一起看看是什么在耗电, 找出主要的耗电来源, 看看哪些地方可以适当调整, 减少您每天需要频繁充电的情况。', '电池/异常/电池老化/耗电', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0034', '在你身边', 'AppleCare', 'AppleCare
当客户抱怨维修时间长时（202607）', 1, 0, '怎么维修一个屏幕需要这么的长时间呢？', '维修时长确实是大家最关心的问题之一。之所以需要2到3周, 主要是因为这不是一个简单的换屏操作, 我们的工厂会做更完整的检测、以及维修后的复测和校准。返厂维修不只是维修或更换部件, 更重要的是确保交还给您的设备符合我们最严格的质量标准, 尽量避免后续不必要的麻烦。2到3周是一个相对稳妥的预估范围, 维修进度也可以随时查询, 我这边也可以帮您关注状态。', '2到3周/完整/质量标准/查询', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0035', '在你身边', 'AppleCare', 'AppleCare
当客户认为维修价格贵时', 1, 0, '你们的报价怎么这么贵啊？找第三方维修店的报价要低很多呢。', '我理解您在考虑不同地方的维修, 以及价格上的差异, 在做决定的时候, 这些都是需要考虑的因素。不少客户都会拿官方和第三方来对比。价格上出现差别, 主要是因为官方维修使用的是100%原厂组件, 维修过程和技术也都严格按照原厂标准执行, 维修后提供的也是原厂质保, 这些是官方维修重点保障的部分。不同地方的维修侧重的点不一样, 您可以从价格、维修质量、以及后续使用的安心和省心程度这些方面来综合判断, 看看哪一种更符合您的需求。另外, 也跟您补充一下, 目前系统显示的2110 是活动优惠价, 相比日常的换屏价格会低一些, 您可以结合刚才这些因素一起考虑一下。', '价格/原厂组件/质保/官方维修', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0036', '在你身边', 'AppleCare', 'AppleCare
售后场景沟通技巧_手机无法充电', 1, 0, '我的iPhone 16手机充不进电了, 换了好几根线都不行, 是不是充电口坏了？', '您好! 手机充不进电确实很让人着急。请您放心, 我们会一步步帮您排查, 找到问题的根源。我们可以先从几个常见原因查起：首先, 充电口非常容易积灰或卡入细小异物, 这会导致接触不良。', '问题/充电口/积灰/接触不良', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0037', '在你身边', 'AppleCare', 'AppleCare
售后场景沟通技巧_手机无法充电', 2, 1, '你可以帮我检测一下吗？', '好的! 我们可以先用专业的工具为您仔细检查并清洁充电口。同时, 我们也会用我们的官方数据线和充电器测试, 排除配件问题。另外, 也可能跟您手机的设置有关, 如果您设置了充电上限, 手机在充电至您设定的上限时也会停止充电。如果配件和设置都没有问题, 我们会进行硬件诊断, 确认是接口问题还是主板供电问题, 并告知您后续的处理方案。', '工具/充电口/官方/硬件诊断/主板供电', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0038', '在你身边', 'AppleCare', 'AppleCare
售后场景沟通技巧_信号问题', 1, 0, '我的手机信号特别差, 在同一个地方, 别人的手机满格, 我的就一两格, 甚至没服务。', '您好! 信号问题确实很影响体验。请您放心, 让我们来为您排查一下问题。影响信号的因素比较多, 比如运营商网络覆盖、SIM卡老化或是手机硬件本身问题。让我们检查一下是否更新了运营商设置, 或者尝试还原网络设置或更换一张SIM卡试试。', '信号/运营商网络/硬件/还原', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0039', '在你身边', 'AppleCare', 'AppleCare
售后场景沟通技巧_信号问题', 2, 1, '我已经换过一张SIM卡了, 没有用, 你还有其他办法吗？', '不要担心。我们可以为您运行一个蜂窝网络诊断, 检查手机的天线和基带是否存在硬件故障。诊断完成后, 我们会清晰地向您说明是软件问题、SIM卡问题, 还是硬件故障, 并根据诊断结果, 为您提供相应的解决方案。您看, 我们现在可以为您进行检查吗？', '蜂窝网络/诊断', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0040', '在你身边', 'AppleCare', 'AppleCare
保修范围沟通场景 (202512)', 1, 0, '我的手机保修期是多久？都保修些什么？', '您好! 您是想了解保修问题吧？没问题, 我很乐于给您相关解答。通常情况下, 所有国行正品iPhone自购买之日起, 都享有一年的有限保修服务。这项保修主要针对的是在正常使用情况下出现的、非人为造成的硬件故障, 例如主板、屏幕、电池等部件的性能问题。', '保修/一年/有限保修/非人为', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0041', '在你身边', 'AppleCare', 'AppleCare
保修范围沟通场景 (202512)', 2, 1, '手机屏幕碎了, 还能保修吗？', '是这样的, 像手机摔碎、进水这类意外或人为损坏, 是不在免费保修范围内的。当然, 如果您之前有给设备购买了AppleCare+ 或 AppleCare服务产品, 那就太好了! 这个服务会为您提供更全面的保障, 不仅会延长保修期限, 而且针对意外损坏也能更优惠的维修服务。您看, 我现在可以帮您查询一下你这台设备的具体保修状态吗？', '免费保修/全面/保修状态', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0042', '在你身边', 'AppleCare', 'AppleCare
保外维修场景沟通 (202607)', 1, 0, '场景说明
客户设备为iPhone 16 Pro Max, 诊断结果显示“摄像头图像质量”执行未通过, 顾客手机摄像头故障。
现在你们检测出来我手机摄像头是有问题, 那具体要怎么处理？', '您好! 感谢您的信任。我理解您现在最关心的是维修方案, 毕竟手机是您日常生活中不可或缺的一部分。根据刚才的诊断结果, 确认是摄像头模块的硬件问题, 考虑到您的设备已经过了保修期, 我们给出的维修方案是为您更换整个后置摄像头组件。', '摄像头/保修期', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0043', '在你身边', 'AppleCare', 'AppleCare
保外维修场景沟通 (202607)', 2, 1, '更换摄像头要多少钱？', '预估的维修费用大概是628元。需要说明的是, 像摄像头这种核心部件的更换, 都需要在拥有专业设备和环境下进行, 所以我们需要将您的设备寄送到指定的维修中心处理, 最终的维修报价会以维修中心给出的为准。我们收到后会第一时间以短信的方式给您发送报价, 在得到您的授权后再进行维修。', '专业设备/维修中心/短信/报价/授权', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0044', '在你身边', 'AppleCare', 'AppleCare
保外维修场景沟通 (202607)', 3, 1, '大概多久才能修好我的手机？', '具体维修周期会因故障复杂程度和备件情况有所浮动。一般来说从寄出到返回大约需要2到3周。设备送修期间也请您保持手机畅通, 您放心, 当维修状态更新时, 我们会通过短信通知您, 您也可以通过微信小程序查询维修进度。您看, 这个维修方案您可以接受吗？', '维修周期/短信通知/微信小程序', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0045', '在你身边', 'AppleCare', 'AppleCare
售后场景沟通技巧_维修价格', 1, 0, '我的手机屏幕摔碎了, 换一个要多少钱啊？', '您好! 看到您的手机屏幕摔碎了, 您肯定特别心疼, 而且这确实会影响日常使用。您别担心, 我们会尽力帮助您解决这个问题。关于屏幕更换的费用, 主要看两点：一是手机型号, 二是您是否购买了AppleCare+服务计划。', '屏幕/费用', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0046', '在你身边', 'AppleCare', 'AppleCare
售后场景沟通技巧_维修价格', 2, 1, '我的手机型号是iPhone17, 没有购买AppleCare+服务计划, 换屏幕是什么价格呢？', '了解! 在给您报价之前, 我们得先给您的手机做个全面的诊断检测。主要是想看看除了屏幕, 有没有其他地方也受损了, 这样才能给您一个准确的方案和价格。检测完成后, 我们会根据具体的检测结果, 为您提供详细的维修报价。整个诊断过程通常只需要几分钟时间, 您看我们现在就可以开始吗？', '诊断检测/维修报价', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0047', '在你身边', 'AppleCare', 'AppleCare
如何解释数据隐私同意书 (202512)', 1, 0, '场景说明
顾客已经同意门店为其设备提供诊断服务, 在提供诊断服务之前, 门店员工需要邀请顾客签署”数据存储及隐私保护同意书”。', '在为您提供诊断服务前, 需要您签署数据隐私同意书。', '', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0048', '在你身边', 'AppleCare', 'AppleCare
如何解释数据隐私同意书 (202512)', 2, 1, '同意书是什么？为什么需要签署数据隐私同意书？', '我来向您解释一下, 根据国家《个人信息保护法》的要求, 向您提供售后诊断和维修服务时, 我们会根据Apple隐私政策收集和处理您的个人信息, 与Apple共享维修服务必须的有限的个人信息, 所以需要征得您的同意。您可以仔细阅读同意书的内容, 如果有任何不明白的地方, 我都非常乐于为您解释。', '个人信息保护法/ 隐私政策/同意书', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0049', '在你身边', 'AppleCare', 'AppleCare
手机卡顿拯救计划 (202510)', 1, 0, '更新了新系统之后, 我感觉手机变得好卡, 打开App都要等半天。', '您好, 我理解, 更新系统后发现手机变卡了确实会有点担心。系统更新后有时会出现短暂的卡顿, 因为手机需要重建索引和缓存, 通常使用一两天后会恢复正常。如果卡顿仍然持续您可以尝试强制重启手机。我们也可以帮您做一些基本检查, 比如手机的存储空间是否充足, 是否开启了低电量模式等, 这些也会导致卡顿。如果问题严重, 我们还可以为您通过电脑连接恢复系统。', '重建索引/强制重启/存储空间/恢复系统', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0050', '在你身边', 'AppleCare', 'AppleCare
关于手机发烫 (202510)', 1, 0, '你看, 我这手机用着用着就特别烫, 尤其是一充电或者玩会游戏, 这正常吗？', '您好, 手机在进行充电或运行大型应用, 比如游戏时, 处理器高速运转会产生一定热量, 轻微发热是正常现象。但如果感觉异常发烫, 我们确实需要重视。有时候软件之间的不兼容或某些程序运行状态不稳定可能也会导致这个问题。我们可以帮您检查一下系统, 看看是否有这类问题。同时, 建议您使用原装充电器, 并避免在高温环境或充电下长时间使用。我们也可以为您做一个免费的硬件诊断, 排除主板等硬件问题, 让您更放心。', '异常发烫 /原装充电器/硬件诊断/放心', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0051', '在你身边', 'AppleCare', 'AppleCare
关于维修费用 (202510)', 1, 0, '维修好我的手机你们收多少费用？', '您好, 关于费用问题, 我们需要先对您的设备进行检测。如果检测结果是非意外或人为损坏导致的硬件故障, 并且您的设备在保修期内, 那么维修是免费的。如果设备已过保修期或者是因进水、摔坏等意外损坏导致, 则需要付费维修。我们会先给您提供详细的报价, 征得您同意后才会进行维修。', '检测/非/人为/保修期内/免费/付费维修/报价', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0052', '在你身边', 'AppleCare', 'AppleCare
电池续航无忧 (202510)', 1, 0, '你好, 我的手机掉电太快了! 经常是早上充满电, 没怎么用, 中午就剩一半了。是不是电池有问题啊？', '您好, 很理解您的感受, 手机续航确实很影响使用体验。为了帮您准确判断问题, 我想先了解几个情况：您手机的系统版本是多少？平时主要用哪些 App呢？电池是消耗品, 随着使用时间的增加会一定程度减少续航时间。如果您刚刚更新了系统, 大量应用程序需要更新, 电池续航也可能会暂时受到影响。我们可以先帮您诊断检查一下电池健康度, 再看一下后台应用刷新和定位服务等设置, 这些都可能影响耗电。如果诊断后确定是电池硬件问题, 我们可以为您安排维修。', '诊断/电池健康度/后台应用刷新/定位服务/维修', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0053', '在你身边', 'AppleCare', 'AC_Mono
维修政策之维修周期 (202607)', 1, 0, '你们大概要多久才能修好我的手机？', '您好, 我们门店是官方授权接机点, 需要将设备送到指定的维修中心进行处理。具体维修周期会因故障复杂程度和备件情况有所浮动。一般来说从寄出到返回大约需要2到3周。设备送修期间也请您保持手机畅通, 当维修状态更新时, 我们会通过短信通知您, 您也可以通过微信小程序查询维修进度。', '官方授权/维修中心/2到3周/短信通知/微信小程序/查询维修进度', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0054', 'iPhone销售话术系列', '推荐产品优势', 'iPhone 17 诚意满满大升级 (202509)', 1, 0, 'iPhone 17 相比上一代有哪些提升？', 'iPhone 17 这次升级可谓诚意满满。
-首先，他支持以前Pro机型才有的自适应刷新率，最高达120Hz，而且峰值亮度可达3000尼特。这是iPhone目前最顶配的屏幕。
-其次，芯片采用最新第三代3纳米制成的A19芯片，处理速度超快，多任务、玩大型游戏都不在话下。它的续航也大幅提升，视频播放最长可达30小时。而且充电速度也更快，搭配高功率适配器，20分钟即可充电50%。
-第三，它的后置双摄都是4800万像素，拍风景、拍微距、拍人物都更加出片。
-第四他的前置镜头升级为1800万像素 Center Stage 摄像头，自拍时可以人物居中，还能灵活旋转，即使纵握手机，也能拍出横向照片，特别适合聚会时拍合影。他还能视频同步双拍，看演唱会时能同时录制现场画面，同时拍自己的反应，特别实用。
-最后就是 256G起步的容量，直接翻了一倍，关键还加量不加价。
今年的基础款一点也不基础，还有五种漂亮的颜色可以选，让人很难不心动。', '自适应刷新率/120/峰值亮度/3000/A19/续航/充电/同步双拍', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0055', 'iPhone销售话术系列', '推荐产品优势', '专业之选 iPhone 17 Pro (202509)', 1, 0, 'iPhone 17 Pro 有什么优势？你给我介绍一下', 'iPhone 17 Pro 无论是从性能、散热、影像、续航还是容量方面，都是最顶级的。
首先，是他极致的性能。他搭载第三代3纳米制成的 A19 Pro 芯片，配合 VC均热板的蒸发冷却技术，散热更高效，持续性能提升最高提升 40%。运行高阶游戏和高强度任务都轻轻松松。
其次，专业级的影像能力，好比随身携带 8个专业镜头。后置三摄全部升级为 4800万像素，长焦镜头提供最高 8倍光学品质变焦，是iPhone有史以来最长的长焦。
视频拍摄也堪比专业设备，可以支持电影级别的拍摄规格，随手一拍都是大片。
第三，它是续航最长的iPhone。 iPhone 17 Pro视频播放最长达 31小时，iPhone 17 Pro Max 高达 37小时。充电也超快，搭配高功率适配器，20分钟即可充满 50%
第四，它正面和背面都采用超瓷晶面板，正面超瓷晶面板2抗刮能力提升3倍，更坚固耐用。
第五，可选容量高达 2T，对于专业用户或经常录视频的用户非常合适。
当然，全新的 1800万Center Stage前置镜头，顶配的屏幕，也都是 Pro机型的标配。还有星宇橙、深蓝色和银色可选，高级感十足。', '芯片/蒸发冷却/40%/8个/长焦/8倍/续航/3倍/2T', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0056', 'iPhone销售话术系列', '推荐产品优势', 'iPhone Air 极致轻薄又强大(202509)', 1, 0, '我挺喜欢iPhone Air 的，他除了薄还有什么特点？', 'iPhone Air 是史上最薄的 iPhone，又超级轻。同时他又配备了最先进的芯片，超长的续航和 6.5英寸的顶配屏幕，还有四种精美颜色可选，拿在手里回头率超高。
它只有5.6毫米，重量也只有165克。边框采用抛光钛金属，机身前后都采用了超瓷晶面板，正面超瓷晶面板2抗刮能力提升 3倍。所以它兼具了纤薄和坚固耐用。
它还搭载了A19 Pro 芯片，从而拥有Pro级的强悍性能。不仅如此，他还有超长的续航，视频播放最高达 27小时，他还支持快充。
另外，它的前置镜头升级为1800万像素Center Stage摄像头，自拍时可以人物居中，还能灵活旋转，即使纵握手机，也能拍出横向照片，特别适合聚会时拍合影。他还能他还能视频同步双拍，看演唱会时能同时录制现场画面，同时拍自己的反应，特别实用。
iPhone Air 采用 eSIM 技术，既安全又灵活。目前 Apple 正与监管机构紧密合作，争取尽快上市。', '最薄/6.5英寸/钛金属/3倍/芯片/续航/27/同步双拍', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0057', 'iPhone销售话术系列', '推荐产品优势', 'iPhone 16 有什么新亮点（202409）', 1, 0, 'iPhone 16 跟老款比，有啥新功能？', '很多之前 Pro 的功能，iPhone 16 现在也有了，甚至更强，比如以下四个方面：
第一是A18 芯片，它是首款第二代 3纳米芯片，直接跨代升级，CPU 速度提升了30%，GPU 提升了 40%；还支持硬件加速光线追踪功能，玩那些对性能要求很高的大型游戏，更流畅了，画面效果更真实。
第二是超广角镜头可以拍微距了，拍出细节满满的照片。
第三是新增的相机控制功能，让您拍照更方便，轻按可以快速开启相机，滑动即可切换功能，让您快速抓拍那些生活中转瞬即逝的时刻。
还有就是续航更长了，iPhone 16 视频播放时长可达22小时，iPhone 16 Plus 可达 27小时。
另外 iPhone 16 也支持 Apple 智能，预计明年发布。', '芯片/光线追踪/微距/相机控制/续航', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0058', 'iPhone销售话术系列', '推荐产品优势', 'iPhone 16 有什么新亮点（202409）', 2, 1, '我有旧手机，可以以旧换新吗？', '有的，那边的机器就可以帮您快速估值，我带您来测一下；而且全产品都支持以旧换新呢。', '', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0059', 'iPhone销售话术系列', '推荐产品优势', '本领叠满超值加持 iPhone 17e（202603）', 1, 0, '这是 iPhone 17e 吧，这手机怎么样？', '这次iPhone 17e 的升级很大, 可以说非常超值。
-首先, 它的起步存储直接翻倍到了 256GB, 是iPhone 16e的两倍, 加量不加价。
-其次, 它搭载了最新的A19芯片, 支持硬件加速的光线追踪, 玩3A大作, 画面也能非常真实流畅。续航方面, 视频播放最长可达26小时, 
比iPhone 11多出9小时。并且支持 USB-C 快充, 30分钟就能充至50%, 彻底告别电量焦虑。
-第三, 它还新加入了 MagSafe 无线充电, 稳固又方便。
-第四, 全新的4800万像素融合式主摄, 不仅拍照清晰, 还支持光学品质的2倍长焦, 轻松拉近拍摄主体。新一代人像功能, 可以让你在拍摄后调整照片的焦点和背景虚化效果。
-最后, 6.1 英寸的超视网膜 XDR 显示屏色彩绚丽、清晰明亮。超瓷晶面板2的抗刮划能力提升了3倍, 更加坚固耐用。
-外观有黑色、白色和全新的浅粉色可选, 总有一款适合您。', '256/A19/26 /无线充电/融合式/2倍/长焦/新一代人像/3倍/浅粉色', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0060', 'iPhone销售话术系列', '推荐产品优势', '向顾客介绍 iOS 26 (202507)', 1, 0, '新发布的 iOS 26有什么更新？什么时候可以升级？', '-这次更新惊喜不少，简单给您列举个亮点吧：
首先界面更美更顺手了。新设计用了半透明的的Liquid Glass效果看起来更高级，还能自定义图标。
另外电话和信息也更聪明了，他能帮您筛选陌生电话，打客服忙线时还会在对方接听时提醒你。
陌生信息会静音，并放到专属文件夹里，不打扰您。
-还有一些更新，比如 Apple Music 能翻译歌词了。
地图会记住您常去的地方，通勤路线一目了然，遇到拥堵还能推荐其他路线。
-所有游戏会集中在一个地方，回到爱玩的游戏、发现新游戏、和朋友一起玩都更方便了。
今年秋季就可以免费升级了，请您耐心等待一下', '设计/电话/信息/翻译/地图/游戏', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0061', 'iPhone销售话术系列', '推荐产品优势', '向顾客介绍
iPhone Air eSIM 优势
 (202510)', 1, 0, '手机上的 eSIM 有什么不同吗？', 'eSIM 是一种数字SIM 卡, 不需要插实体卡, 就能激活手机号码。相比传统SIM 卡, eSIM 有至少两点优势：
-更安全：手机丢了或者被偷, eSIM 不会像实体卡那样被拔走或盗用。
-更方便：不用带着实体卡, 也不用担心换卡时弄丢。出国旅行切换当地eSIM 也更简单。', '更安全/更方便', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0062', 'iPhone销售话术系列', '推荐产品优势', '向顾客介绍
iPhone Air eSIM 优势
 (202510)', 2, 1, '我从国外买的 iPhone Air 能用吗？', '您在国外购买的iPhone Air 无法激活中国大陆运营商的 eSIM, 如果您希望使用国内运营商的 eSIM 服务, 建议您在中国大陆授权门店购买iPhone Air, 每台eSIM 手机下最多存在2个有效号码。', '授权门店/2个', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0063', 'iPhone销售话术系列', '推荐产品优势', '向顾客推荐 iPhone 在游戏方面的优势
（202604）', 1, 0, '这款机器玩游戏怎么样？', 'iPhone 17 Pro 性能强大，续航更长，非常适合玩游戏，比如玩3A大作《明日方舟：终末地》。
首先，它的 A19 Pro 芯片搭配 VC 均热板带来持续性能，而且持久冷静，满血输出不掉帧，您可以试试用最新的 S+ 级角色“庄方宣”放大招，打这种满级 Boss战，性能比上一代提升多达40%，手感依然顺滑不卡顿。
其次，就是硬件加速的光线追踪技术，让游戏有身临其境的光影质感，画面特别细腻，您看它的环境、光效和反射效果，将游戏逼真度提升至全新境界，让探索和战斗更有沉浸感，就像在看科幻大片一样真实。
另外，还有游戏模式，优化系统资源分配，减少发热和掉帧，在高负荷场景下画面丝滑流畅，提升游戏体验。', '均热板/光线追踪/游戏模式/发热/掉帧', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0064', 'iPhone销售话术系列', '推荐产品优势', 'iPhone 17 买赠活动（202605）', 1, 0, '场景
看到顾客在看 iPhone 17, 记得主动推荐iPhone 17的买赠活动, 促成销售', '今天购买iPhone 17 有好礼! 现在店内入手, 赠送一个第三方品牌充电器, 符合要求的机型还可叠加国补, 算下来特别划算。活动到6月27日就结束, 机会难得!', '17/赠送/第三方/充电器', '2020-01-01', 'archived');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0065', 'iPhone销售话术系列', '推荐产品优势', 'iPhone 17 买赠活动（202605）', 2, 1, '只有 iPhone17 才有活动吗？', '对的, 这个福利目前只有 iPhone 17 可以享受。而且我看 iPhone 17 刚好特别符合您的要求, 现在入手性价比很高的。', '性价比', '2020-01-01', 'archived');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0066', 'iPhone销售话术系列', '推荐产品优势', 'iPhone 17 买赠活动（202605）', 3, 1, '行，那我要怎么弄？', '特别简单, 不用您做任何复杂的认证。充电器我等会儿直接跟新手机一起给您打包带走! 至于那个国家补贴, 我这就教您, 领完结账直接当钱扣, 即买即得!', '简单', '2020-01-01', 'archived');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0067', 'iPhone销售话术系列', '常见顾客问题', '三款新 iPhone区别在哪 我该怎么选？（202509）', 1, 0, '新出的这三款iPhone 各自有什么特点，我该怎么选？', '这三款机型各有自己的定位和特色，我给您介绍一下：
iPhone 17 是超值之选，A19芯片、自适应刷新率的屏幕、双4800万像素摄像头、前置的 1800万Center Stage摄像头、超强续航加快充、256G 起步的容量，每一项都能打，关键还是加量不加价。
iPhone Air 具有满满的未来科技感。 他是迄今最薄的iPhone，而且超轻。同时又坚固耐用，关键是它的性能并没有妥协，采用 A19 Pro芯片，还有超长续航和快充。屏幕也采用了6.5英寸的顶配屏幕。eSIM 的应用，也为用户增加了安全性和灵活性。
iPhone 17 Pro 就是地表最强iPhone，集所有的黑科技于一身。最强的 A19 Pro芯片搭配创新的蒸发冷却技术，性能超强又散热好，还有最长的续航。后置三颗摄像头全4800万，能拍8倍光学品质长焦，具有专业级的影像能力，前置摄像头也采用了全新的 1800万Center Stage摄像头。最高可选2T容量版本。可以说是极致之选。', 'A19/自适应刷新/续航/快充/256G/最薄/蒸发冷却/8倍', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0068', 'iPhone销售话术系列', '常见顾客问题', 'iPhone Air
eSIM 办理条件 (202510)', 1, 0, '场景：顾客对如何办理 eSIM 有些疑问
eSIM业务怎么办理呢？', '在您去营业厅办理开通 eSIM 之前, 建议您在微信搜索“一证通查”查询, 也可以到附近营业厅或致电营业厅查询您是否可以办理 eSIM。
然后本人带着身份证原件和iPhone Air 去营业厅完成激活, 并测试通信功能, 确保 eSIM 手机业务开通效果。
每台iPhone Air 手机最多可以绑定2个号码。', '查询/身份证原件/iPhone Air', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0069', 'iPhone销售话术系列', '常见顾客问题', 'iPhone Air
eSIM 办理条件 (202510)', 2, 1, '听说一定要带着手机去营业厅办理？', '是的, 在运营商eSIM 业务商用试验阶段, 需要您在营业厅内完成eSIM办理激活。
营业厅会核验eSIM手机, 确保手机具备支持eSIM业务的硬件与系统条件；办理完成后现场把办理的eSIM号码下载到手机中, 确保eSIM业务开通成功, 这样您就能顺利使用新手机啦! 
建议您购买手机后先迁移旧手机数据, 再去营业厅开通 eSIM。', '营业厅', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0070', 'iPhone销售话术系列', '深入了解卖点', '顶尖级拍摄系统
iPhone 17 Pro（202510）', 1, 0, 'iPhone 17 Pro 的后置摄像头有什么优势？', 'iPhone 17 Pro 的三摄系统非常强大，无论是拍照片还是拍视频都很专业，很多摄影师和专业博主都强烈推荐。
首先，它搭载三颗 4800万像素融合式摄像头，分别是主摄、超广角和长焦，可以丝滑切换8个焦段，相当于8个专业镜头随身带，能够捕捉到清晰、细节丰富的图像。
第二，出色的长焦拍摄能力。全新的4800 万像素长焦镜头采用新一代四重反射棱镜设计，并搭载比上一代增大 56%的传感器，支持 8倍光学品质变焦，是iPhone 迄今最长的长焦。带着它去演唱会、动物园，都能拍到清晰的特写和细节。
第三，低光环境下拍摄能力超强。经过升级的光像引擎技术能更好地保留原始细节，减少噪点，并大幅提升色彩准确度，尤其是在弱光环境下，能够拍摄出高质量的照片。
第四，新一代摄影风格功能让您的照片更具个性化。新增的“珠光”风格，可提亮人物肤色，让照片更明艳更有活力，特别适合亚洲人的肤色。
第五：超强的视频拍摄能力，甚至可以达到电影级别。iPhone 17 Pro 可以拍摄最高4K120fps 杜比视界视频，还首次支持了ProRes RAW，使画质飞跃式的提升。它还支持 Apple Log 2和 Genlock，为专业视频创作者提供了强大的创意空间。', '8个/长焦/传感器/8倍/摄影风格/珠光/视频/杜比视界', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0071', 'iPhone销售话术系列', '深入了解卖点', '1800万前摄破框而出
（202510）', 1, 0, '听说 iPhone 17 系列前置摄像头提升挺大的，给我介绍一下', 'iPhone 17 系列的前置摄像头升级很大，而且非常实用。
首先，它的像素升级到1800 万像素，而且首次采用了正方形的传感器，视野更广、分辨率更高，能够捕捉更丰富的细节。
第二，自拍合照时，人物居中功能可以非常智能地检测多个人物，自动扩大视角，并可从纵向模式自动转为横向模式，将所有拍摄对象收入画面。这个功能非常实用，聚会拍合照再也不用横着手机拍了。
第三，新一代摄影风格功能让您的照片更具个性化。新增的“珠光”风格，可提亮人物肤色，让照片更明艳更有活力，特别适合亚洲人的肤色。
第四，前置摄像头还能拍 4K HDR 视频，而且防抖超稳。同步双拍功能可以同时使用前置和后置摄像头录制视频，比如看演唱会时能同时录现场画面和自己的反应，特别实用。', '正方形/人物居中/摄影风格/珠光/防抖/同步双拍', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0072', 'iPad销售话术系列', '推荐产品优势', '推荐“eSIM iPad 乐享 5G” 超值优惠活动（202412）', 1, 0, '顾客走到iPad 柜台前，请主动向 TA 推荐“eSIM iPad 乐享 5G”超值优惠活动', '您好！我们现在有个超级优惠活动！购买 eSIM版 iPad mini 和 iPad Air 超值超划算！最高立省1100元，甚至比Wi-Fi 版的还划算！', '优惠/1100', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0073', 'iPad销售话术系列', '推荐产品优势', '推荐“eSIM iPad 乐享 5G” 超值优惠活动（202412）', 2, 1, '什么意思？怎么省 1100？', '就是您购买eSIM版iPad mini 或者iPad Air，机器本身直降600，同时还可以免费赠送您价值300元，中国联通为期一年 300G 流量的5G 套餐。另外，如果您有旧机器参加以旧换新，还能额外获得200元换新补贴。三项加起来相当于立省1100元，买到就是赚到！', '600/300/300G/200/换新补贴', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0074', 'iPad销售话术系列', '推荐产品优势', '推荐“eSIM iPad 乐享 5G” 超值优惠活动（202412）', 3, 1, '你说eSIM版是什么意思？和普通iPad 有什么不一样吗？', 'eSIM iPad 能独立连 5G 上网，而且不用插卡，不用去营业厅办理，直接线上就能激活。
它相比 Wi-Fi 版有很多优势：
﻿﻿首先，在外面不一定都有Wi-Fi, eSIM 版 iPad 开机即连 5G 上网。追剧、直播、玩游戏、办公都特别方便。
﻿﻿而且，一般公用的 Wi-Fi 都不太稳定，速度也慢。还是用 5G 上网速度更快、更稳定。
﻿﻿更重要的是，eSIM 版的 iPad 更安全，因为它不需要连接陌生的 Wi-Fi，不用担心连接钓鱼网站，泄露隐私。', '独立/5G/线上/激活/开机即连/更快/稳定/安全/隐私', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0075', 'iPad销售话术系列', '推荐产品优势', '推荐“eSIM iPad 乐享 5G” 超值优惠活动（202412）', 4, 1, '那我连手机热点不就解决了？', '热点还得费手机的电，而且还得用手机流量，我们直接送您300G，多划算。而且开机即连 5G，不用经常重连热点，多方便啊。
您想想花 Wi-Fi 版的钱，就能把 eSIM 版 iPad 带回家。相当于 eSIM 功能是白送您的，您真的可以闭眼冲，错过就没有了', '电/流量/300G/开机即连5G', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0076', 'iPad销售话术系列', '推荐产品优势', 'iPad mini 小巧又强大（202410）', 1, 0, '这是 iPad mini 吧，怎么样?', 'iPad mini 有四种颜色，小巧便携，一只手拿着也很轻松，是通勤路上最佳的选择。
它性能也很强，用的是 A17 Pro 芯片，支持硬件加速的光线追踪，让你畅玩 3A 游戏大作。续航最长可达10 小时。
另外，它的屏幕支持原彩显示和 P3 广色域，可以显示锐利的文字和生动的色彩。
最后，它支持 Apple Pencil Pro 和 Apple Pencil (USB-C),无论是记笔记，还是绘画创作，既直观又精准。', '四种颜色/小巧便携/性能/芯片/光线追踪/游戏/续航/原彩显示/广色域', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0077', 'iPad销售话术系列', '推荐产品优势', 'A16 芯片 iPad，多彩又强大（202503）', 1, 0, '场景：顾客走到 iPad 柜台前, 拿起了配备 A16芯 片的iPad。
这个是搭载 A16芯片的iPad吧, 有什 么特点？', '首先, 它搭载了 A16 芯片, 性能很强, 不管是处理工作还是剪辑 4K 视频, 都特别流畅。续航最长可达10小时。 
另外, 它配备了 11英寸的 Liquid 视网膜显示屏, 追剧, 玩游戏效果很棒。 它一共有 4种颜色可选, 还可以搭配 Apple Pencil 和键盘, 记笔记、画画都很不错。而且起始容量翻倍, 加量不加价。', '性能/续航/视网膜/颜色/容量', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0078', 'iPad销售话术系列', '推荐产品优势', '向顾客介绍 iPadOS 26（202507）', 1, 0, '新发布的iPadOS 26有什么新特性？什么时候可以升级？', '首先它采用全新设计Liquid Glass带来半透明的质感，能够反射和折射周围的环境，同时能凸显重要的内容;
其次全新窗口系统可以同时打开更多窗口顺畅调整App窗口大小和位置，同时可与台前调度搭配使用将窗口整理成不同分组，也可搭配外接显示器，提供更多空间进行更多任务操作;
此外, 文件App还提供了文件夹自定义选项包括自定颜色,图标表情符号等,还可以在不同设备同步,非常方便; 
最后全新的预览App可以对PDF和图片用Apple Pencil或触控进行绘制草图, 查看, 编辑并标记, 并使用自动填充功能快速填写PDF表格，让工作更有效率; 
今年秋季就可以免费升级了，请您耐心等待一下。', '半透明/窗口系统/台前调度/显示器/文件夹/同步/预览/自动填充', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0079', 'iPad销售话术系列', '推荐产品优势', 'iPad 11 全能选手，超高性价比（202508）', 1, 0, '场景1
国补券发放期间, 客户担忧抢券失败, 你需要重点化解顾客担忧并告知门店促销活动。
你说说现在买iPad11有什么活动吗？国补活动还有吗？', '给您推荐我们这款全新iPad 11 (A16芯片) , 性价比超高, 现在有多重超值优惠活动：
1：国补, 抢券成功能立减, 
128G 减450元! 256G和512G 最高能减500元! 
2：咱们授权店独家折上折! 
128G的再减80元! 256G和512G的再减280元! 
不管您抢没抢到国补券, 在咱店都能享受独家补贴, 要是抢到国补券, 那就是“店补”＋“国补”双重福利, 怎么算都很划算, 这优惠只有咱们官方授权店才有。并且国补虽然力度不小, 但也随时可能停止, 建议您早买早享受。
另外, 我们门店还提供分期付款和以旧换新服务, 您购买更加灵活方便。', '国补/折上折/ 官方/授权店/分期付款/以旧换新', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0080', 'iPad销售话术系列', '推荐产品优势', 'iPad 11 全能选手，超高性价比（202508）', 2, 1, '场景 2
你发现顾客对产品功能和优惠活动都不熟悉，需全面展示核心优势与优惠活动
你给我介绍一下这个 iPad 11', '给您推荐我们这款全新iPad 11 (A16芯片) , 性价比超高, 还有优惠活动, 非常值得入手。
首先, 11寸的Liquid视网膜显示屏, 显示效果细腻清晰, 看剧、看资料, 视觉体验非常舒服! 
其次, A16芯片的加持, 速度比上一代足足快了50%! 您同时开几个应用、或者玩大型游戏, 都非常流畅, 一点不卡顿! 
给孩子学习用：海量的教育资源, 而且安全可靠, 家长放心。您自己办公用配上Apple Penci 或者智能键盘, 记笔记、处理文档效率直接翻倍! 
这款iPad是市场绝对的首选, 超过80%的用户都选它, 现在入手, 价值真的超值! 128G的版本, 容量比之前64G的翻了一倍! 价格反而直降了800快! 咱们作为Apple授权店, 还有独家“折上折”128G的：再给您减80! 
256G或512G的：再减280! 还能再享受国补优惠双重叠加! 
另外, 我们店还提供分期付款和以旧换新服务, 您购买更加灵活方便。', '显示屏/芯片/办公/折上折/分期付款/以旧换新', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0081', 'iPad销售话术系列', '推荐产品优势', 'iPad 11 全能选手，超高性价比（202508）', 3, 1, '场景3
现在买 iPad 11有什么优惠？', '给您推荐我们这款全新iPad 11 (A16芯片) , 性价比超高, 还有优惠活动, 非常值得入手。
1：国补优惠128G 减450元! 256G和512G 最高能减500元! 
2：咱们授权店独家折上折! 128G的再减80元! 256G和512G的再减280元! 
这种叠加优惠的力度只有咱们官方授权店才有！
另外，我们门店还提供分期付款和以旧换新服务，您购买更加灵活方便。', '国补优惠/折上折/官方授权店/分期付款/以旧换新', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0082', 'iPad销售话术系列', '推荐产品优势', '高能猛进 iPad Pro M5 （202510）', 1, 0, 'iPad Pro M5 有什么主要升级点吗？', '这次 M5芯片 iPad Pro 的升级主要集中在性能和快充方面。
首先是全新 M5 芯片，基于第三代 3纳米制程，且新一代10 核图形处理器配备了强大的神经网络加速器，专业渲染性能相比 M1 的 iPad Pro 最高达6.7倍，各类 AI任务的处理速度也大幅提升。与此同时，它的续航依然很给力，观看视频最长可达 10小时。再配合新推出的40W 动态电源适配器，30分钟就能充至 50%，摆脱电量焦虑。
另外，它还延续了顶级 iPad 的使用体验：首先是极致的轻薄，13英寸厚度只有5.1毫米，是最薄的Apple 产品。超精视网膜 XDR 显示屏，采用全新的双层串联 OLED技术，带来超高全屏亮度，和200万比1的超高对比度，满足了专业用户对色彩精准度的要求。横向超广角前置摄像头自带人物居中功能，四扬声器系统和四录音棚级麦克风，让您无论追剧打游戏还是开视频会议，都有出色的体验。
最后，它全系标配雷雳/USB 4 端口，能外接高速存储、专业显示器甚至扩展坞。如果再搭配 Apple Pencil和键盘，无论绘画设计和办公，都非常好用。', 'M5 /第三代 /神经网络 /AI /续航 /最薄 /显示屏 /对比度 /人物居中', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0083', 'iPad销售话术系列', '推荐产品优势', '超拉风的 iPad Air （M4）
（202603）', 1, 0, 'iPad Air 怎么样, 这次有什么更新？', 'iPad Air 升级为 M4芯片, 性能比 M1 机型快了2.3倍。无论是用 FinalCut Pro 剪视频、在 Pixelmator Pro 里修图, 还是玩支持光线追踪的3A大作, 都无比流畅。它的 AI 能力也大幅提升, 16 核神经网络引擎速度比M1 快3倍, 内存升级到 12GB, 像 Goodnotes 里搜索手写笔记这类任务瞬间完成, 而且电池续航依然能撑一整天。
 其次, 它的连接能力一步到位, 支持Wi-Fi 7 和蓝牙6, 联网又快又稳。蜂窝版还能用eSIM随时切换套餐, 出差、旅行都方便。
 第三, 绚丽的高分辨率 Liquid 视网膜显示屏, 色彩精准、亮度高, 还带抗反射涂层, 户外看得清。机身采用100%再生铝金属, 提供深空灰、星光色、蓝色和紫色四种时尚配色。
 最后, 它的摄像头和音频也很棒。前置支持人物居中, 视频通话时自动跟着你走。横向立体声扬声器加双麦克风, 音效立体饱满, 拍视频时还能智能降噪。
 无论是学习、创作还是娱乐, 这台iPad Air 都能让你得心应手。', 'M4/ AI/ 连接/显示屏/人物居中/横向/双麦克风', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0084', 'iPad销售话术系列', '应对个性需求', '向学生顾客介绍 iPad（202305）', 1, 0, '场景：通过交谈，你了解顾客是一位大学生，正在考虑购买一台 iPad 作为日常学习使用，你决定主动推荐一下...', 'iPad 非常适合日常学习使用。
首先，它可以同时运行多任务，使用分屏和画中画，你可以一边上网查资料，一边记笔记，还能同时看网课视频。
搭配 ApplePencil，你还可以随手记下思路，画个草图。如果再配上键盘，就能像电脑一样快速打字输入了。
另外，iPad 更轻薄便携，续航能用一整天，带着去图书馆更方便。', '多任务/分屏/画中画/键盘/轻薄/续航', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0085', 'iPad销售话术系列', '应对个性需求', '向学生顾客介绍 iPad（202305）', 2, 1, '场景： 你演示了 iPad 多任务，快速备忘录和键盘输入快捷键等功能,请参考 SEED 上“iPad 情景式演示-用来学习”
iPad 支持专业的应用吗?比如编程之类的。', 'iPad 上专业应用很全。计算机编程，视频剪辑、音乐绘画等专业都可以找到对应的应用。而且 iPad 性能很强，屏幕显示效果好，可以满足各种专业的需要。', '专业应用/性能/屏幕', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0086', 'iPad销售话术系列', '应对个性需求', '向办公族介绍 iPad（202305）', 1, 0, '场景：通过交谈，你了解顾客是一位白领，有办公电脑，正在考虑购买一台 iPad 作为日常办公的补充~
iPad 能用来办公吗?', 'iPad 非常适合办公，而且很高效。
首先，它支持各种常用的办公软件，比如 Offce 系列，WPS，钉钉等等。您也可以选用 Apple 自己的办公软件，免费还好用。
它还可以运行多任务。比如使用分屏，你可以一边写文档，一边和同事打字交流。新增的台前调度功能，可以在多个工作场景快速切换，互不干扰。', '办公软件/多任务/分屏/台前调度', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0087', 'iPad销售话术系列', '应对个性需求', '向办公族介绍 iPad（202305）', 2, 1, '场景：你向顾客演示了办公软件和多任务功能，请参考 SEED 上“iPad 情景式演示-比电脑还好用/用来办公”
还挺不错的，还有其他的吗?', '开视频会议也很方便，比如使用腾讯会议的时候，可以打开语音突显功能，来屏蔽周围的噪音，还可以打开人像，来虚化背景。人物居中功能，可以让你在移动时，也始终保持在画面中央。
搭配 Apple Pencil，您还可以随手记下会议纪要，画个草图。如果再配上键盘，就能像电脑一样快速打字输入了。
另外，您还可以把日程安排、待办事项这些小组件，直接放在桌面上，一目了然。', '视频会议/语音突显/人像/人物居中/键盘/小组件', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0088', 'iPad销售话术系列', '应对个性需求', '向专业绘画的顾客推荐 iPad Pro（202408）', 1, 0, '场景
通过交谈，你了解顾客时以为对设备有专业需求的插画师，正在考虑购买一台 iPad Pro。', '首先，iPad Pro 配备了超精视网膜XDR 显示屏，采用双层串联 OLED 技术，亮度更高、色彩更精准、屏幕响应也更快，更适合专业画师。
您还可以搭配 Apple Pencil Pro一起使用，它有像素级别的精准度、超低延迟、倾斜角度感应，还有轻捏、侧旋、触觉反馈等功能，可以提升绘画效率。
最后，13英寸的iPad Pro 非常轻薄，厚度只有5.1毫米，是最薄的 Apple 产品，方便外出采风时携带。
我可以给您演示一下。', '超精视网膜/双层串联/亮度/色彩/屏幕响应/轻捏/侧旋/触觉反馈/轻薄', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0089', 'iPad销售话术系列', '应对个性需求', 'iPad Air 适合玩大型游戏吗？（202503）', 1, 0, 'iPad Air 能玩大型游戏吗？ 效果怎么样？', 'iPad Air 搭配 M3 芯片, 支持硬件加速的光线追踪。
非常适合玩大型游戏, 像《燕云十六声》这种高品质的游戏, 也可以流畅运行, 效果拉满 ～ 首先, M3芯片速度极快, 达到 M1 芯片的近 2 倍。
在玩大型游戏时,  仍然可以效果全开, 打斗场面流畅, 不会出现卡顿、掉帧的情况。 
另外, 它的 Liquid 视网膜显示屏支持 P3 广色域, 横向立体声扬声器使游戏非常具有沉浸感, 视听体验超棒。 
最后, iPad Air 支持第三方手柄, 比如 PS, Xbox 等, 玩游戏操作更专 业, 更顺手。', '芯片/光线追踪/显示屏/广色域/横向/立体扬声器/手柄', '2020-01-01', 'archived');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0090', 'iPad销售话术系列', '解答常见问题', '家长担心孩子玩 iPad 耽误学习，如何应对(202308)', 1, 0, '我担心孩子用 iPad 光玩游戏了，影响学习。', '这个您完全不用担心。iPad 上的“屏幕使用时间”功能，可以让您清楚地看到孩子用了哪些 App，每个花了多长时间，这样您就可以掌握孩子的学习和娱乐情况了。
另外，您还可以通过“App 限额”功能，限定游戏娱乐类 App 的使用时间，比如每天最多玩一小时，从而让孩子专注在学习上。
如果您想让孩子按时睡觉，可以通过“停用时间”功能来限制整个 iPad 的使用时间，比如设置 iPad 到晚上 10 点就停止使用。', '屏幕使用时间/App 限额/停用时间', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0091', 'iPad销售话术系列', '解答常见问题', '纳米纹理玻璃和标准屏幕有什么区别（202405）', 1, 0, '听说 iPad Pro 有个什么纳米抗反射屏，它和普通屏有什么区别？', '您说的应该是，新款 iPad Pro 可选纳米纹理玻璃的屏幕。这种屏幕可以降低外界光线的反射，有效减少眩光，更适合在复杂光线下使用 iPad 的用户和追求精准色彩的专业用户，比如摄影师和设计师。', '纳米纹理玻璃/眩光', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0092', 'iPad销售话术系列', '解答常见问题', '纳米纹理玻璃和标准屏幕有什么区别（202405）', 2, 1, '为什么只有 1TB 以上的才有这个选项？', '因为刚才提到的专业用户，通常需要更多的存储空间来处理大型文件，所以只有 1T 和 2T 版本的 iPad Pro 会提供这个选项。', '', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0093', 'iPad销售话术系列', '解答常见问题', 'iPad Pro 的屏幕好在哪里？（202406）', 1, 0, '听说 iPad Pro 的屏幕很好，具体好在哪里？', 'iPad Pro 采用了超精视网膜 XDR 显示屏，它基于突破性的双层串联 OLED 技术，视觉效果非常震撼。
具体表现在：
第一，双层 OLED 面板的光线经过叠加融合，可以实现超高的亮度，全屏亮度可达 1,000尼特，HDR 峰值亮度可达1,600尼特。这样在看照片、视频的时候，屏幕更加的明亮清晰。
第二，可以对每颗像素点色彩和亮度精准控制，因此可以呈现更深邃的黑色，播放动态内容时，屏幕响应也更加灵敏流畅，色彩更加准确。让你在玩游戏、看电影的时候，沉浸感十足。
第三，对比度可以达到惊人的 200万:1，因此在显示文字的时候更加锐利清晰。
第四，还有纳米纹理玻璃选项，专业用户在不同光线下使用时，可以减少眩光', '超精视网膜/双层串联/全屏亮度/峰值亮度/像素点/色彩/对比度/纳米纹理玻璃', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0094', 'iPad销售话术系列', '解答常见问题', '我该选要怎么选 iPad Air 还是iPad Pro呢？
(202603)', 1, 0, '我该选 iPad Pro 还是 iPad Air 呢？', 'iPad Pro 是最顶级的iPad, 适合追求高性能、极致轻薄和极致影音体验的顾客。
iPad Pro 配备了强大的M5芯片, 专业渲染和 Al任务也能轻松应对。超精视网膜XDR 显示屏, 支持 ProMotion 自适应刷新率技术, 显示效果非常惊艳。它还支持四扬声器系统和四麦克风阵列, 让您无论追剧打游戏还是开视频会议, 都有出色的体验。
  iPad Air 各方面表现也很优秀, 而且价格相对实惠一些。最新版升级到M4芯片, 应对日常使用绰绰有余, 而且还升级了更快的 Wi-Fi和蓝牙标准。它也同样轻薄便携, 还有多彩的外观, 不管您是用来日常使用、上课办公或者打游戏, 也都完全胜任。', 'M5/超精视网膜/自适应刷新率/扬声器/麦克风/M4/轻薄便携', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0095', 'iPad销售话术系列', '解答常见问题', '11寸 iPad Air M4 以旧换新专属补贴活动
（202604）', 1, 0, '刚刚发现顾客对 iPad产品感兴趣是，你可以主动向顾客推荐 11英寸 iPad Air M4 「以旧换新」补贴活动', '今天 iPad 超划算！用任意估值超过 ¥100的苹果旧设备或安卓手机换购新款 11英寸的 iPad Air立减400元，还可以叠加10%补贴，为你省下一笔不少费用。活动到5月23日结束，机会难得！', '11/iPad Air/补贴', '2020-01-01', 'archived');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0096', 'iPad销售话术系列', '解答常见问题', '11寸 iPad Air M4 以旧换新专属补贴活动
（202604）', 2, 1, '只有 11英寸 iPad Air才有活动吗？', '根据您的需求，新款 11英寸的 iPad Air非常合适，能满足您的使用场景，且深受用户欢迎，我可以为你演示多任务和Apple Pencil的使用。', '多任务/Apple Pencil', '2020-01-01', 'archived');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0097', 'iPad销售话术系列', '解答常见问题', '11寸 iPad Air M4 以旧换新专属补贴活动
（202604）', 3, 1, '我家里有个旧款，今天没带怎么办？', '这完全没关系！您今天可以全款把11英寸的iPad Air带回家，7天内您抽空把旧机器一起拿过来，我们当场给您补上这立减的400元和10%换新补贴。咱们回收流程很正规，数据隐私都有保障的，您旧款苹果设备是什么？我现在就帮你算算，这波操作下来能给您省下很多钱！', '7/换新补贴/隐私', '2020-01-01', 'archived');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0098', 'Mac销售话术系列', '推荐产品优势', 'Mac 好搭档 Studio Display(202304)', 1, 0, '场景：你看到顾客正在 Studio Display 前仔细查看，你走了过去..
你能介绍一下这个显示器吗?', '这款显示器功能非常多，尤其是和 Mac 电脑一起使用。它的 5K 高清显示屏，具有 600 尼特的高亮度，在不同的光线环境下，画面都非常清晰细腻，色彩鲜艳。它的摄像头具有人物居中功能。在进行视频通话时，即使您来回走动，您始终会保持在画面中央。同时，高保真六扬声器、录音棚级三麦克风阵列组合，音效非常棒还有通话降噪功能。', '5K/亮度/摄像头/人物居中/视频通话/六扬声器/三麦克风', '2020-01-01', 'archived');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0099', 'Mac销售话术系列', '推荐产品优势', 'Mac mini 尺寸爆减实力暴涨（202411)', 1, 0, '你能帮我介绍一下 Mac mini 吗？', 'Mac mini 是一台体型超迷你，性能超强的台式主机，只需4000多块钱，就能体验到最新的 M4 系列芯片和16 GB起步的统一内存。相比 M1 版本，性能提升最高达1.8倍。
全新的处理器，无论是处理海量数据的 Excel 表格，还是剪视频、编程、3D渲染等都非常流畅。新的硬件加速光线追踪技术，让玩游戏体验更好。
它前后有8个接口，您可以轻松连接各种设备，最多可以同时连接三台显示器。', '超强/光线追踪/接口', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0100', 'Mac销售话术系列', '推荐产品优势', '全新多彩 iMac 的四大卖点（202411）', 1, 0, '我打算买一台电脑家用，你可以给我介绍一下 iMac 吗?', 'iMac 很适合家用、学习或办公。
首先它外观超薄、有七种颜色可选，不管放哪儿都特别漂亮。
其次，它搭载了全新的 M4 芯片，性能非常强大，标配速度更快的 16GB 统一内存，无论是玩游戏、做视频、编程、3D 渲染等都很轻松。
它的神经网络引擎，比 M1 快 3倍，是世界领先的 AI 一体机。
另外，宽大的 24 英寸 4.5K 视网膜显示屏，支持原彩显示和 P3 广色域，显示效果清晰亮丽。可以选配纳米纹理玻璃，能有效减少反光，特别适合靠窗或明亮环境下使用。
最后，它新增的12MP Center Stage 摄像头，支持人物居中与桌上视角，搭配高保真六扬声器和录音棚级三麦克风阵列，非常适合在家娱乐、上网课、开视频会议。', '超薄/芯片/神经网络/原彩显示/广色域/纳米纹理/人物居中/桌上视角/六扬声器/三麦克风', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0101', 'Mac销售话术系列', '推荐产品优势', '实力高飞的 MacBook Air （M5）
（202603）', 1, 0, '我听说新出的MacBook Air 换了 M5芯片, 具体有
哪些升级？值不值得换？', '首先, 它搭载了全新的M5芯片, 10核CPU和最多10核GPU, AI任务处理速度比M4 快最多 4倍, 比M1快最多9.5倍。统一内存带宽达153GB/S, 相比 M4 提升 28%, 多任务切换、App 启动都更流畅。续航也大幅提升, 最长18小时, 还支持快充, 出门一天不用带电源。
  其次, 它的存储直接翻倍, 起步就是512GB, 最高可选4TB, 固态硬盘读写速度提升2倍。无论是导入大型素材库还是加载游戏, 都快人一步。
  第三, 支持Wi-Fi7 和蓝牙6, 搭配自研 N1 芯片, 联网又快又稳。两个雷雳4接口可连接两台外接显示器, MagSafe 充电更安心。
  第四, 13.6或15.3英寸 Liquid 视网膜屏, 亮度可达500尼特, 支持P3广色域和原彩显示, 文字清晰、画面鲜艳。机身厚度不到1.2厘米, 15英寸的重量也才1.5千克, 无风扇静音设计, 便携又安静。
  最后, 它配备了 1200万像素 Center Stage 摄像头, 支持桌上视角, 视频通话时既能人物居中, 又能展示工作台面。扬声器系统支持空间音频和杜比全景声, 看剧听歌都有沉浸式体验。
  Mac BookAir 提供天蓝色、午夜色、星光色和银色四种配色, 高级又环保。无论是学习、办公还是创作, 都是不错的选择。', 'M5/统一内存/续航/ 18 /512/广色域/ 原彩显示/人物居中/扬声器', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0102', 'Mac销售话术系列', '推荐产品优势', '选择 MacBook Air(M1)的理由(202304)', 1, 0, '场景：你发现顾客正在浏览 M1 的 MacBook Air，你走了过去.
我想买一个笔记本电脑，你能给我介绍一下这台笔记本嘛?', '好的，这台 MacBook Air 无论是办公还是学习都是不错的选择。首先，这台电脑性能出色，M1 芯片运行超快。电池续航长达 18 小时，轻松应对各种任务。
其次，视网膜显示屏画质清晰，文档、幻灯片阅读更舒适。 P3 广色域让色彩更丰富。此外，宽大的触控板无需外接鼠标就可完成各种操作，比如快速滚动和缩放。
最后，它还自带免费办公软件 iWork，支持 Office，与其他 Apple 产品配合使用非常方便。', '性能/续航/显示屏/触控板/办公', '2020-01-01', 'archived');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0103', 'Mac销售话术系列', '推荐产品优势', 'Mac Studio 小巧精悍高性能(202503)', 1, 0, '我想换个好点的电脑，Mac Studio 怎么样?', '它是很棒的一台台式机。 首先, 它的性能非常强, 可选 M4 Max 或 M3 Ultra 芯片, 最高可配置 512GB 统一内存, 轻松搞定 3D 渲染、8K 视频剪辑, 还能在本地部署超 6 千亿参数的大语言模型, 是理想的 AI 高性能电脑。 
另外, 它的接口也特别多, 可以连接各种设备, 还能同时连接多台显示器 Mac Studio 体积小, 运行起来特别安静。 您能跟我说说目前的使用需求吗？', '性能/芯片/接口/体积小/安静', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0104', 'Mac销售话术系列', '推荐产品优势', '向顾客介绍 macOS 26（202507）', 1, 0, '新发布的 Mac系统有什么更新？什么时候可以升级？', '首先，Liquid glass半透明设计风格，让Mac看起来新颖高级，菜单栏完全透明，显示屏显得更宽大。
你还可以做更多个性化设置，用颜色和符号来定制文件夹的外观，灵活地布局控制中心，打造你独有的Mac。另外，新的聚焦搜索，找东西又快又准，搜索结果排序更智能，还能直接找第三方云盘上的文件。
你还能直接在这里进行数百项操作，比如发送电子邮件或创建备忘录。
还有一些实用的更新，比如全新的电话App让Mac和iPhone一样有完整的通话体验。
还有，实时活动也能在Mac上查看了，比如你的网约车到哪儿了、航班状态、球赛比分都能查看，很方便。
新系统秋季推出，您到时候可以免费升级。', '半透明/个性化/聚焦搜索/电话/实时活动', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0105', 'Mac销售话术系列', '推荐产品优势', '强势动力 MacBook Pro M5 和 M4 系列（202510）', 1, 0, 'MacBook Pro有什么优势，强在哪里？', 'MacBook Pro 是最强大的 Mac 笔记本电脑，非常适合对性能要求高的用户，有14和16英寸两种尺寸，以及银色和深空黑色可选。
首先它们的性能非常强劲。全新搭载M5 芯片的机型，处理速度相比M1 机型最高达6倍，处理各类 AI任务的速度也大幅提升。很适合高校学生和商务用户。
M4 Pro 机型性能更加强悍，更适合工程师，软件开发者等专业人士。M4 Max 机型是 Mac 笔记本中最强的，对于AI开发者、影视工作者、3D 特效从业者非常合适。
另外，它的续航也是最厉害的。以M5 机型为例，最长可达24小时，还支持快充，只需30分钟，就能充至最高50%。特别适合需要出差或移动办公的用户。
此外，它的显示效果也是最好的。配备 Liquid 视网膜XDR 显示屏，支持自适应刷新率技术，能提供高亮度、高对比度、色彩绚丽的显示效果。
最后，它的接口丰富，可连接多种专业外设。高保真六扬声器和录音棚级三麦克风阵列提供非常出色的音频效果。', '性能/ 续航/快充/显示 /自适应刷新率/接口/扬声器/麦克风', '2020-01-01', 'archived');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0106', 'Mac销售话术系列', '推荐产品优势', '全员疾速派
MacBook Pro (M5 Pro/Max) 
（202603）', 1, 0, '新升级的 MacBook Pro, 芯片能力表现怎么样？还
有什么优势？', 'MacBook Pro 新搭载了 M5 Pro 和 M5 Max 芯片, 可以说是性能怪兽。
  首先, 图形处理器中的神经网络加速器, 让 AI性能相比M1系列机型最快达8倍, 图像生成、提示词处理、本地模型训练等各类 AI任务都能轻松驾驭。中央处理器强大的多线程性能, 加上统一内存再次提速, 让您做什么都快的超乎想象。
  其次, M5 Pro 机型存储从1TB起步, M5 Max 从 2TB 起步, 固态硬盘速度也最高达之前两倍。统一内存可以灵活选配, 最高可选到128GB, 带宽也更高了, 处理多条 8K 视频流或多任务 AI训练, 也不在话下。
  第三, 绚丽的 Liquid 视网膜XDR显示屏, 对比度高达一百万比一, HDR 峰值亮度可达1600 尼特, ProMotion 自适应刷新率技术, 最高可达120 Hz, 可以适配您各种专业的显示内容和工作环境。电池续航最长可达24小时, 支持快速充电, 让您彻底摆脱续航焦虑。
  第四, M5 Pro 和 M5 Max 机型标配雷雳5端口, 可提供最高达 120Gb/s 的数据传输速度。M5 Max 机型甚至可以同时连接4台高分辨率显示器, 打造自己的工作站。
  最后, 1200万像素 Center Stage 摄像头, 支持人物居中和桌上视角, 视频会议时既能自动跟随, 又能展示工作台面。录音棚级麦克风加高保真六扬声器系统, 支持空间音频, 无论剪片、审听音乐、还是追剧都非常沉浸。
  机身有14和16英寸两种尺寸, 银色和深空黑色可选。对专业用户说, MacBook Pro 就是移动办公的终极选择。', '神经网络加速器/统一内存/对比度/亮度/自适应刷新率/24小时/5
/摄像头/人物居中', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0107', 'Mac销售话术系列', '推荐产品优势', '超值之选
MacBook Neo 
(202603)', 1, 0, '这个新出的MacBook Neo, 怎么样？日常使用够
吗？', 'MacBook Neo 完全可以满足日常使用的需求, 非常适合学生、轻办公的场景。
  首先, 它的外观非常抢眼, 有四种漂亮的颜色, 就连键盘、触控板也是同色系。同时它非常轻薄便携, 厚度和重量跟 MacBook Air 差不多。
  其次, 它搭载了 A18 Pro 芯片。像 Safari、Office、飞书、钉钉、WPS等常用软件同时开好几个也不卡顿, 系统依然流畅。内置的神经网络引擎支持本地AI功能, 帮你更高效地处理创意任务。电池续航最长16小时, 适合全天学习或工作。
  第三, 13英寸 Liquid 视网膜显示屏, 支持10亿色彩和 500尼特亮度, 清晰鲜艳。前置 1080p 高清摄像头, 配合双麦克风阵列, 视频通话画面清晰、声音清楚。双侧向发声扬声器支持杜比全景声的空间音频, 听音乐、看电影都很沉浸。
  第四, 配备两个 USB-C接口和一个3.5毫米耳机插孔, 对习惯用有线耳机的同学特别友好。512G版本还配有 触控ID, 解锁和支付一键搞定。
  最后, 如果你用的是iPhone, 就可以享受连续互通功能了, 比如, 可以用iPhone 镜像直接在 Mac上操作手机, 用通用剪贴板跨设备复制粘贴等等。
  这台 MacBook Neo 既有颜值又很好用, 非常超值。', '轻薄便携/芯片/16小时/色彩/亮度/高清摄像头/扬声器/耳机/触
控ID/连续互通', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0108', 'Mac销售话术系列', '推荐产品优势', '选择 MacBook Air(M2) 的理由(202411)', 1, 0, '你可以给我介绍一下这款 M2 的 MacBook Air 吗?', '我从四个方面为您介绍一下： 
首先它屏幕尺寸为13英寸, 非常轻薄, 而且采用了一体成型技术, 携带轻便又坚固耐用。 
其次, M2芯片拥有超强的处理能力, 现在起步就是16GB 统一内存,  加量不加价, 让您轻松应对日常工作和专业应用。 
它的 Liquid 视网膜显示屏, 屏幕更大、边框更窄。还支持10亿色彩,  浏览照片和观看影片效果都非常出色。 
最后是出色的影音体验。1080P高清摄像头、三麦克风阵列和四扬声器系统, 不仅视频通话更清晰, 听音乐和看视频效果都非常好。', '轻薄/一体成型/坚固耐用/芯片/16GB/显示屏/三麦克风/四扬声器', '2020-01-01', 'archived');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0109', 'Mac销售话术系列', '应对个性需求', '向学生党介绍 Mac 电脑(202411）', 1, 0, '我现在上大学，想买一台电脑。我觉得 Mac 挺不错的，但是又担心不适合我。', '对于学生来说, Mac 电脑是个很好的选择。
它的 M 系列芯片性能强大, 显示效果出色, 坚固耐用, 安全稳定, 续航长达一整天, 非常适合日常学习使用。 Mac 有丰富的专业软件, 无论是设计、编程还是视频剪辑, 都能满足您的需求。
同时, 它还有像 Keynote 和 Pages 这样强大免费的学习工具。 如果您用iPhone 或iPad, Mac 还能无缝连接, 方便传输文件和同步数据。
你还能用iPhone 镜像 App 直接使用iPhone上独有的App。 Mac保值率高, 加上教育优惠, 非常超值。 
您有哪些具体需求？我来帮您推荐一款合适的Mac。', '性能/显示/坚固耐用/ 续航/专业软件 /无缝连接/镜像/保值/教育优惠', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0110', 'Mac销售话术系列', '应对个性需求', '向办公族介绍 Mac 电脑
(202411)', 1, 0, '我想看看 Mac 电脑，我主要是日常办公使用，你可以给我介绍一下嘛?', '您好! Mac 电脑非常适合日常办公。
首先, Apple 自己设计的M 系列芯片性能强大, 续航长达一整天, 保障你的工作效率。Mac 有先进的病毒防护机制、免费的macOS 系统升级, 系统稳定可靠, 让你不用担心广告和病毒骚扰。 
新增的12MP Center Stage 摄像头, 支持人物居中和桌上视角, 让你开会分享更自由。Mac上还有聚焦搜索、专注模式等实用功能, 让您工作更专注。 
另外, Mac 自带的办公套件非常好用, 当然也支持您熟悉的 Office。 您还能在应用商店里找到腾讯会议、百度网盘、钉钉这些常用的工具。 
最后, 通过隔空投送, 您可以很容易地和同事传送文件。 
您还有什么特别需求吗？我来为您推荐适合您的Mac 电脑!', '芯片/续航/系统稳定/人物居中/桌上视角/聚焦搜索/专注模式/应用商店/隔空投送', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0111', 'Mac销售话术系列', '解决常见问题', 'Mac 能装 Windows 吗?
(202411)', 1, 0, 'Mac 电脑能装 Windows 吗?', 'M 芯片的 Mac 都可以通过安装 Parallels 虚拟机来装 Windows。', '虚拟机', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0112', 'Mac销售话术系列', '解决常见问题', 'Mac 能装 Windows 吗?
(202411)', 2, 1, '什么是虚拟机?好安装吗?', '虚拟机是一个应用程序, 不用重启就可以直接在上面运行 Windows。 它安装非常简单, 只需要到它的官网下载, 然后按照步骤安装即可。它还会帮你自动下载和安装 Windows。', '应用程序/安装非常简单', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0113', 'Mac销售话术系列', '解决常见问题', 'Mac 能装 Windows 吗?
(202411)', 3, 1, '虚拟机是免费的吗?下载和安装 Windows 要收费吗?', '目前 Parallels 虚拟机可免费试用14天, 之后需要付费 (标准版498一年或748一次性购买) 。下载和安装 Windows 是免费的, 但激活需收费。另外, 在 Windows 上安装软件的收费情况也和之前在PC上是一样的。', '', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0114', 'Mac销售话术系列', '解决常见问题', 'Mac 能装 Windows 吗?
(202411)', 4, 1, '它和安装双系统有什么区别?', '虚拟机使用起来更方便, 启动 Windows 就像打开一个软件窗口一样简单。你可以在两个系统之间直接复制和粘贴, 或者拖动文件, 而且 Windows 应用都能运行, 包括一些经典的 Windows 专属游戏。', '更方便', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0115', 'Mac销售话术系列', '解决常见问题', 'Mac 能装 Windows 吗?
(202411)', 5, 1, '虚拟机运行速度快吗?稳不稳定?占用的空间和内存有多大?', '虚拟机运行速度快, 也很稳定, 而且 Mac 触控板的基本手势都能用。 它大概需要几百兆空间, 再算上Windows 系统, 整体大概需要25GB 空间。占用内存可以按需修改, 默认是最高占用一半 CPU 和内存。', '速度快/很稳定', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0116', 'Mac销售话术系列', '解决常见问题', '帮顾客选择合适的 MacBook（202603）', 1, 0, 'MacBook这么多型号和处理器版本, 它们分别适合什么样的用户呢？该怎么选择？', 'MacBook Neo 可以认为是入门款, 比较适合学生、轻办公人群或者处理日常事务等等。对应的使用场景比如像 Safari 上网, 编辑 Office和WPS, 使用飞书、钉钉这类办公软件等等, 它们可以多任务同时运行, 也不会卡顿。当然简单的修图和视频剪辑, 或者本地 AI 的功能也都是没问题的。
  如果用户想要更强的性能、更大的屏幕、更大的起步容量和内存以及更长的续航, 可以选择M5芯片的MacBook Air 它对用专业院校的大学生、办公族或者自媒体博主等都非常合适, 属于轻便型的生产力工具, 用来剪4K视频也没有问题。
  MacBook Pro 就是妥妥的生产力工具了, 它的性能和续航、内存和存储容量、屏幕和扬声器都是顶配的, 接口也更丰富。适合视频剪辑师、AI 工程师、电影或者音乐领域的专业人士等。', '多任务/性能/屏幕/续航/生产力/扬声器/接口', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0117', 'Mac销售话术系列', '解决常见问题', 'Mac 能玩游戏吗?
 (202603)', 1, 0, '我之前经常用 PC 玩游戏，那 Mac 适合玩游戏吗?', 'Mac 上有很多游戏可以玩。
  首先, 在 Mac 应用商店里面就有很多游戏, 也可以安装 Steam 玩3A大作。同时, 一些热门的iPhone 和iPad 游戏也可以在Mac上玩, 比如鸣潮, 崩坏3等。
  其次, Mac处理速度超强, M5 系列芯片都配备了超高性能的图形处理器, 并且支持硬件加速光线追踪, 让游戏画面更加流畅逼真。Liquid 视网膜XDR 显示屏, 支持自适应刷新率技术, 能提供高亮度、高对比度、色彩绚丽的显示效果。
  MacBook Pro 的高保真六扬声器, 配合 Mac 的游戏模式, 能带来更震撼且沉浸式的游戏体验。', '应用商店/性能/光线追踪/自适应刷新率/扬声器/游戏模式', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0118', 'Mac销售话术系列', '解决常见问题', 'MacBook Neo
常见问题 (202603)', 1, 0, 'MacBook Neo 是专为学生设计的吗？', 'MacBook Neo 的受众包括但不限于学生。
如果用户需要一台价格亲民、品质卓越的笔记本, 能轻松搞定日常使用, 比如上网、处理文档、在线追剧等等, 那么 MacBook Neo 是理想选择。', '价格亲民', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0119', 'Mac销售话术系列', '解决常见问题', 'MacBook Neo
常见问题 (202603)', 2, 1, 'MacBook Neo 用上一代手机的芯片, 性能够吗？', '现在A 系列芯片的处理能力并不逊色, 随着中央处理器、图形处理器和16核神经网络引擎的不断进化, A18 Pro 可以满足用户所需：无论是流畅处理日常事务、快速切换各类 apps, 还是玩转创意项目, 或是驱动App内的AI功能, 都不在话下。
  对于学生、轻办公, 处理日常文档、表格、PPT等, 这样的使用场景, 完全够用了, 而且极具性价比。
  当然, 对于追求更强性能、更大的屏幕和更多能力的用户来说, 搭载M5芯片的 MacBook Air 是一个绝佳选择。', '中央处理器/图形处理器/神经网络引擎/学生/ 轻办公', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0120', 'Mac销售话术系列', '解决常见问题', 'MacBook Neo
常见问题 (202603)', 3, 1, 'MacBook Neo 和同级别 PC相比, 有什么优势？', 'MacBook Neo 是一款独一无二的产品。
  它采用精美耐用的铝金属设计, 拥有四种活泼的颜色。从屏幕、键盘、触控板, 到摄像头、扬声器和麦克风, 样样都与同价位产品不同, 体验更出众。
  它由 Apple 芯片驱动, 可以做到开盖即用、快速唤醒, 续航最长可达16小时。
  它搭载的 macOS 系统安全又稳定。如果你有其他Apple 产品, 比如iPhone, 还能体验Apple 生态系统带来的便利。
  所以 MacBook Neo 是同价位中的优选。', '铝金属/颜色/ 芯片/续航/16小时/生态系统', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0121', ' Watch销售话术系列', '推荐产品优势', '满手高招的 Apple Watch Series 11 (202509)', 1, 0, 'Apple Watch 11 这次有什么提升？', '他主要是从耐用性、续航和连接5G这三个方面的提升。
-首先，它的屏幕抗刮划能力是上一代的两倍，降低了表盘划伤的概率。
-其次，续航从最长18小时提升到24小时，减少了续航焦虑。
-第三，蜂窝网络版本支持5G了，独立上网速度更快，下载App，听音乐更迅速流畅。
今年还有个软件功能更新，可以给睡眠评分了。它会综合多个睡眠因素进行打分，睡得好不好一目了然。
-同时Apple Watch Series11 在健康、运动和日常使用方面有很多先进的功能，比如血氧、心率，心电图，睡眠，各种运动数据监测等等，还有摔倒检测和车祸检测这种安全功能，关键时刻可以挽救生命。
您对哪个方面感兴趣？我再给您详细介绍一下。', '抗刮划/续航/24/5G/睡眠评分/血氧/心率/心电图/摔倒检测/车祸检测', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0122', ' Watch销售话术系列', '推荐产品优势', '无限你的野 Apple Watch Ultra3 (202509)', 1, 0, '这是最新的 Ultra 3吧？给我介绍一下吧', '它是最先进的 Apple Watch，各方面的性能是最强的，而且坚固耐用。
首先，他的屏幕亮度高达3000尼特，而且在上一代的基础上加入了广视角，在阳光下或者有一点角度去看，都能看得清。
另外，芯片相比上一代升级为S10芯片，运行速度更快，续航也提升到了48小时，低电量模式下更有72小时的超长续航。
第三支持了5G，独立上网速度更快，下载App听音乐更迅速流畅。
它还有很多功能是专门为极限运动设计的，如果你感兴趣，我可以给您介绍一下。', '屏幕亮度/广视角/S10/48/5G', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0123', ' Watch销售话术系列', '推荐产品优势', '无限你的野 Apple Watch Ultra3 (202509)', 2, 1, '行，那你说说都有什么?', '它有几个功能特别适合耐力、登山和潜水等极限运动。
-首先，它有双频 GPS，即使在复杂的都市中也能穿梭自如。 
-其次，它有双扬声器系统和三麦克风阵列，声音更大，收音效果也更好。更适合在恶劣天气或嘈杂环境中通话。
-另外，它还支持100米防水和40米潜水，入水可以自动显示水深、水温等信息。它还能适应海拔-500米到 9000 米，零下 20 度到 55 度的极端环境。在寒冷、炎热的环境下也能正常运行。
-最后，紧急情况下，它能发出86分贝的警笛，180米远的地方也能听到求救信号。', '双频/双扬声器/三麦克风/防水/潜水/极端环境/警笛', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0124', ' Watch销售话术系列', '推荐产品优势', '你的超值之选 Apple Watch SE3 (202509)', 1, 0, '新出的 SE 3怎么样？有什么新功能吗？', 'Apple Watch SE 3 非常具有性价比，支持大多数的健康、运动和日常通讯等功能，像心率、睡眠、各种运动数据监测、接打电话和收发信息等。他还支持摔倒检测和车祸检测等安全功能在危险时刻能挽救生命
相比上一代，它新加入了体温感应功能，可以在睡眠时候监测体温变化，特别是对于女性可以帮助回推估算排卵日。
芯片升级到了最新的S10芯片，处理速度更快了，像轻翻手腕、双指互点两下这样的手势也可以支持了。
另外，蜂窝网络版本支持5G了，独立上网速度更快，下载App，听音乐更迅速流畅。', '心率/睡眠/运动/车祸检测/摔倒检测/体温感应/S10/5G', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0125', ' Watch销售话术系列', '推荐产品优势', '向顾客介绍watchOS 26 (202507)', 1, 0, '新发布的手表系统有什么更新？什么时候可以升级？', '首先，他的健康功能更智能了，能根据你的实时心率、配速、距离，还有活动圆环数据，提供个性化语音激励，就像请了个私教！
另外，还新增了一个轻翻手腕的功能，轻翻一下手腕就可以快速关闭通知、来电、计时器和闹钟，返回表盘也可以这么用。
当另一只手被占用的时候，这个功能非常方便。
最后从外观上它基于Liquid Glass全新设计，像是一种半透明的全新材料，能够反射和折射周围环境，看起来高级又漂亮。
今年秋季就可以免费升级了，请您耐心等待一下。', '语音/轻翻手腕/半透明', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0126', ' Watch销售话术系列', '应对个性需求', '购 Apple Watch 赠精美第三方表带春节特别活动', 1, 0, '场景
顾客来到 Apple Watch 柜台前，于是你迎上前去', '您好！为了迎接马年新春，店里推出“购 Apple Watch 赠精美第三方表带”限时活动。购买任意一款 Apple Watch，即可免费获赠一条第三方精美表带。
您可以从5款马年专属表带或9款时尚表带中任选一条，这个活动非常难得，是线下门店专属的，数量有限，先到先得。', '任意一款/第三方/5款/马年专属/9款/数量有限/先到先得', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0127', ' Watch销售话术系列', '应对个性需求', '购 Apple Watch 赠精美第三方表带春节特别活动', 2, 1, '马年专属表带听起来不错，是什么样的？给我介绍一下', '您可以看一下陈列。马年专属表带共有5种喜庆的配色，表扣微金色的磁吸扣，形成撞色的设计。并且采用液态硅胶材质，抗汗耐脏、佩戴舒适。
关键它的压纹寓意很好，马头压纹象征马年“昂扬进取、奋发向上”的精神内核；马蹄压纹寓意“步步向前、踏福而行”，传递新春美好祝愿。
戴在手腕上不仅提升节日氛围，也能讨个好彩头。您可以试戴感受一下。', '金色/磁吸/液态硅胶/马头压纹/马蹄压纹/试戴', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0128', ' Watch销售话术系列', '应对个性需求', '购 Apple Watch 赠精美第三方表带春节特别活动', 3, 1, '戴在手上感觉不错，挺好看的。购买直接就能领吗？活动什么时候结束？', '没错，只要购买任意一款 Apple Watch，就可以马上领取。活动截止到3月8日，不过赠品数量有限。每个顾客限领取一条，送完为止哦。', '', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0129', ' Watch销售话术系列', '应对个性需求', '向新用户介绍拥有 WATCH 的三大理由(202303)', 1, 0, '场景
顾客来到柜台，拿起 Apple Watch 看了起来。你主动迎上前去~
Apple Watch 都能做什么?', 'AppleWatch 有很多用处，主要体现在三方面:首先是健康方面，它可以随时监测心率、血氧，还能生成心电图，睡觉的时候佩戴，可以监测睡眠质量和体温变化。这些数据可以让您更了解自己的健康情况。
第二是运动方面，它有丰富的运动类型，比如跑步、游泳、瑜伽、徒步等等，每种运动都有专业的运动数据，让您运动起来更有效果，更专业。
最后是生活方面，当有电话、微信、通知的时候，都会在手腕上提醒您。还有一些很方便的功能，比如支付，导航，刷公交地铁，帮您找手机，合影时遥控拍照等等。
您对哪方面比较感兴趣，我再详细给您讲讲。', '心率/血氧/心电图/睡眠/体温/运动类型/运动数据/提醒/支付/导航', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0130', ' Watch销售话术系列', '应对个性需求', '向爱运动的顾客介绍 WATCH(202303)', 1, 0, '场景
你正在向顾客介绍 Apple Watch 的基本功能，当你说到运动和健身的时候，顾客一下子来了兴致 ….
我看健身房里好多人都戴这个手表，运动时戴它有什么用?', 'AppleWatch 的体能训练 app，支持非常多的运动类型，比如跑步，游泳，瑜伽，户外单车等等。每种运动都能提供很多专业数据，比如跑步时的动态卡路里、心率、距离、步频和配速等等。这样您就能更了解自己的运动情况，更科学有效地运动。', '体能训练/专业数据', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0131', ' Watch销售话术系列', '应对个性需求', '向爱运动的顾客介绍 WATCH(202303)', 2, 1, '演示
你向顾客演示了 Apple Watch 的体能训练 app(请参看 SEED《Apple Watch 情景式演示-健身与健康》)
还不错，运动的时候能用上，还有别的吗?
接下来，你继续向顾客介绍 Apple Watch 的三个圆环', '健身记录 app 有活动、锻炼、站立三个圆环，可以帮助您在日常生活中养成少坐，多动，常锻炼的好习惯。它还会通过挑战赛和奖章的方式来激励您多运动。', '健身记录/活动/锻炼/站立', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0132', ' Watch销售话术系列', '应对个性需求', 'Apple Watch 适合老人佩戴吗？（202408）', 1, 0, 'Apple Watch适合给老人戴吗？', 'Apple Watch非常适合老人用。
首先，Apple Watch有很多健康方面的功能，可以监测血氧，做心电图，还能在心率过高或者过低的时候提醒及时就医。
你还可以通过健康共享功能，将老人的健康数据同步到自己的手机上，多一分安心。
如果老人不小心摔倒， 摔倒检测功能还能主动拨打急救电话并通知紧急联系人。这样您不在老人身边的时候，也能更放心。
另外，老人可能经常听不到电话或者微信，Apple Watch可以在手腕上震动，提醒来电。这样老人就不容易错过电话和信息了。', '健康/血氧/ 心电图/心率 /提醒/摔倒检测/健康共享/电话', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0133', ' Watch销售话术系列', '应对个性需求', 'Apple Watch 适合给孩子买吗？（202408）', 1, 0, 'Apple Watch适合小孩带吗？', 'Apple Watch 很适合给小孩用。
首先，孩子随时随地都能与你许可的联系人打电话、发信息，让您随时和孩子保持联系。
另外，它还能让您知道孩子的位置。比如到达或离开学校，都会收到通知。
孩子还可以通过 SOS 紧急联络功能，快速求助，让您更安心。
如果您担心孩子玩手表影响学习，“课堂时间”可以限制孩子对 Apple Watch 的使用，让孩子专心学习。', '电话/信息/位置/课堂时间/紧急联络', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0134', ' Watch销售话术系列', '应对个性需求', '向关注健康的顾客介绍 WATCH(202410)', 1, 0, '场景
你正在向顾客介绍 AppleWatch 的基本功能当你说到健康和安全的话题时，顾客一下子来了兴致 …
健康安全这方面，你多给我介绍一下吧。', 'Apple Watch 时刻监测您的多种健康数据，是您全天侯的健康助手：
首先，它可以随时监测心率。当心率过高、过低或心率不齐时，会及时提醒。它还有心电图功能，作为心脏健康的参考。
另外，它还能测血氧，让您随时了解自己的血氧饱和度。
如果睡觉的时候佩戴，不仅可以详细了解睡眠质量，还能测量体温变化情况，对于女性，可以更准确地预测经期和排卵日。
全新生命体征app，可以监测你在睡眠时各项健康指标，比如心率，呼吸频率，血氧等等，有任何异常还能立刻提醒你。', '心率/血氧/睡眠质量/体温/经期/排卵日/生命体征', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0135', ' Watch销售话术系列', '应对个性需求', '向关注健康的顾客介绍 WATCH(202410)', 2, 1, '演示并继续介绍
你向顾客演示了心率数据、测血氧、经期跟踪 app (请参看 SEED 《Apple Watch 情景式演示-健身与健康》)
你继续向顾客介绍 Apple Watch 在紧急情况下的安全功能~', 'Apple Watch 还有一些在紧急情况下，很有用的功能。
车祸检测和摔倒检测，可以在发生严重事故的时候，自动拨打救援电话，并且通知紧急联系人。
遇到危险的时候，长按侧边按钮，也能快速报警或者叫救护车。', '车祸检测/摔倒检测', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0136', ' Watch销售话术系列', '应对个性需求', 'Apple Watch 你的睡眠管家
（202510）', 1, 0, '戴着 Apple Watch 睡觉有什么帮助？', 'Apple Watch 可以帮你深入了解自己的睡眠情况, 还能更直观地掌握自己的健康状态。 
首先它能帮你养成良好的睡眠习惯。临近就寝时, Apple Watch 将自动发送提醒, 并开启睡眠模式, 同步静音iPhone、Mac 等设备通知, 给你创建更好的睡眠环境。 睡眠中, Apple Watch 可以准确记录睡眠时长, 以及精准识别不同睡眠阶段, 包括清醒、快速动眼、核心和深度睡眠, 还能记录夜间醒来的时刻。更神奇的是, 它还能给你的睡眠评分, 睡得好不好一目了然。 
另外, 睡眠中的健康数据是非常重要的指标。Apple Watch 可以在你睡眠中记录心率、呼吸频率、手腕温度和血氧数据, 这些信息将汇总在生命体征 app 里, 如果有异常, 就能轻易发现,  是您的健康卫士。 
最后, 起床的时候, Apple Watch 可以轻柔地震动手腕把您唤醒, 从而避免闹钟把您惊醒。', '睡眠模式/睡眠时长/睡眠阶段/睡眠评分/心率/呼吸频率/手腕温度/血氧/生命体征', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0137', ' Watch销售话术系列', '应对个性需求', '向顾客介绍 Apple Watch 房颤历史功能（202603）', 1, 0, '场景：在介绍 Apple Watch 的健康功能时，你了解到顾客患有房颤
听你介绍，心率提醒和心电图功能都挺好的，我本身就有房颤', '那我建议您打开房颤历史功能，这对您的健康非常有帮助。
Apple Watch 可以帮您记录房颤发作的频率，并且以周为单位向您推送通知。您可以在健康app中清晰地看到发生房颤的历史记录，包括可能影响房颤的生活因素，如睡眠、酒精摄入、运动等。
您还可以导出 PDF 文档，共享给医护人员，以便更深入地交流病情。这项功能已经通过国家相关部门认证，准确率非常高。', '通知/健康/PDF', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0138', ' Watch销售话术系列', '应对个性需求', '店员佩戴 Apple Watch 样机增加销售体验项目', 1, 0, '场景
顾客对 Apple Watch 产生兴趣，正在端详展台上的手表，于是你主动迎上前去，自然地展示你手腕上的设备', '您好！您在看 Apple Watch 吗？我刚好正在用这款表，它真的成了我生活中离不开的好帮手。不只是一个看时间的工具，它更像是我手腕上的生活伙伴，无论是运动、通勤还是健康管理，都非常实用。我可以跟您分享一下我是怎么用它的吗？', '正在用/生活伙伴/实用/分享', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0139', ' Watch销售话术系列', '应对个性需求', '店员佩戴 Apple Watch 样机增加销售体验项目', 2, 1, '好啊，我看它上面有三个彩色的圆环这是做什么用的？', '这是 Apple Watch 最经典的健身记录圆环，分别记录您的活动、锻炼和站立情况。您看我这款，我今天已经走了 8000步，红色的活动圆环快合上了！它每小时还会轻轻点按手腕提醒我站立一分钟。这对像我这样经常久坐的人来说真的非常贴心，每天闭合圆环已经成了我的小乐趣。', '活动/锻炼/站立/久坐/闭合圆环', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0140', ' Watch销售话术系列', '应对个性需求', '店员佩戴 Apple Watch 样机增加销售体验项目', 3, 1, '听起来挺健康的。那我平时通勤坐地铁，可以直接用它来刷卡吗？', '完全可以！它支持快捷交通卡功能。我每天早高峰挤地铁时，再也不用手忙脚乱地找手机了。只要抬起手腕靠近闸机，叮的一声就能通过，连面容解锁都不需要。就算有时候电量很低，它依然可以刷卡，绝对是通勤路上最棒的帮手。', '快捷交通卡/电量', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0141', ' Watch销售话术系列', '应对个性需求', '店员佩戴 Apple Watch 样机增加销售体验项目', 4, 1, '这倒是挺方便的。那它还有什么其他特别实用的功能吗？比如健康方面的？', '有的，它在健康管理上非常专业。比如我最近很关注睡眠质量，戴着它睡觉就能自动追踪不同的睡眠阶段。今早看记录发现深睡眠时间有点短，它就提醒我注意调整作息。如果您也注重健康管理，它真的能给您很多直观的参考。', '健康管理/睡眠质量/睡眠阶段/调整作息', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0142', ' Watch销售话术系列', '应对个性需求', '店员佩戴 Apple Watch 样机增加销售体验项目', 5, 1, '不错，但我看表盘好像都差不多，能自己换好看的界面吗？', '当然可以，个性化是它的一大亮点。您看这是我自己搭配的表盘，刚好和我的衣服很搭。界面上我还加了降水概率和接下来的日程安排。您可以根据每天的穿搭和心情，随时切换不同的风格，它完全可以成为展现您个人风格的标志。', '个性化/搭配/日程安排/穿搭/个人风格', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0143', ' Watch销售话术系列', '应对个性需求', '店员佩戴 Apple Watch 样机增加销售体验项目', 6, 1, '这倒是挺方便的。对了，我这人比较丢三落四，经常在家里随手放下手机就找不到了，用这个手表能帮忙找手机吗？', '绝对可以！这简直是我每天都在用的神仙功能，您只需要按一下手表侧边按钮点一下这个手机图标，您的iPhone 就会立刻发出很响的提示音，哪怕手机调了静音也会响。如果您长按这个图标手机背面还能会闪光，就算掉沙发缝里或者晚上关了灯，也能一眼找到。以后再也不用满屋子乱转，或者借别人的手机打电话找了。', '侧边按钮/提示音/静音/闪光', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0144', ' Watch销售话术系列', '应对个性需求', '购 Apple Watch 赠精美第三方表带活动（202607）', 1, 0, '顾客来到 Apple Watch柜台前，于是你迎上前去', '您好！店里推出“购 Apple Watch 随心搭”活动。购买任意一款 Apple Watch，即可免费获赠一条第三方精美表带。您可以从 9 款时尚表带中任选一条。这个活动非常难得，是线下门店专属的，数量 有限，先到先得。', '任意/第三方/9/数量有限/先到先得', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0145', ' Watch销售话术系列', '应对个性需求', '购 Apple Watch 赠精美第三方表带活动（202607）', 2, 1, '随心搭表带听起来不错，是什么样的？给我介绍一下', '这组“随心搭表带”共有9款，色彩丰富百搭，您可以看下陈列：
「双排扣孔款」4种颜色，清爽中性风，非常时尚，男女皆宜。亲肤硅胶久戴无压痕，银色金属扣牢固方便，日常或运动都能轻松hold住。
「双排凹槽款」3种颜色：夏日运动本命！多孔设计告别闷汗黏腻。低调黑扣配高弹透气硅胶，健身或商务场景都简约大气。
「磁吸Z扣款」2种颜色：细节质感拉满。黑色磁吸扣一碰即合，单手秒穿脱，不用再费力对孔位，绝对是懒人福音。
这几款带着都很舒服，您喜欢哪种风格？我帮您拿出来试戴感受一下！', '双排扣孔款/4/时尚/硅胶/双排凹槽款/3/多孔/2/磁吸扣/试戴', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0146', ' Watch销售话术系列', '应对个性需求', '购 Apple Watch 赠精美第三方表带活动（202607）', 3, 1, '感觉不错，也挺好看的。购买后直接就能领吗？活动什么时候结束？', '没错，购买任意一款Apple Watch，就可以马上领取。不过赠品数量有限，每个顾客限领一条，送完为止哦！', '马上领取/限领一条', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0147', ' Watch销售话术系列', '应对个性需求', 'Apple Watch 七夕节活动（202607）', 1, 0, '七夕节来了，请主动向为挑选礼物的顾客介绍 Apple Watch 七夕节专属活动。你面带微笑，可以这样说～', '您好！是在为七夕挑礼物吗？您可以看看 Apple Watch，它不仅是贴心的生活助手，还有专属的浪漫小功能。现在买正好有七夕活动，送特工手链和定制礼盒，“腕间叠搭”特别时髦，送人仪式感满满！', '七夕/礼物/手链/礼盒', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0148', ' Watch销售话术系列', '应对个性需求', 'Apple Watch 七夕活动（202607）', 2, 1, '都有一些什么功能？', '给您举几个例子！对方戴上它之后，日常抬手就能刷地铁进站；工作忙会提醒起身活动；晚上还能监测睡眠，特别贴心。更浪漫的是情侣互动——您还可以把自己的心跳直接发到对方手腕上，让对方感受到真实的震动！平时还能发发小涂鸦。送这款表，就像是给了一份全天候的贴身陪伴。', '刷地铁/活动/监测睡眠/心跳/涂鸦', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0149', ' Watch销售话术系列', '应对个性需求', 'Apple Watch 七夕活动（202607）', 3, 1, '嗯，挺有意思的。送的手链搭配起来好看吗？', '非常好看！这条手链是七夕特供的，和Apple Watch 戴在一起做“腕间叠搭”特别时髦。再配上我们专属礼盒，仪式感直接拉满。对方打开的瞬间，绝对能感受到您的满分心意！', '时髦/仪式感/满分心意', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0150', ' Watch销售话术系列', '解答常见问题', '两者有什么区别 Apple Watch Series11 和 SE
（202509）', 1, 0, 'Apple Watch Series 11和 SE有什么区别？', 'Series 11有更多先进功能，而SE更具性价比。
比如，Series11在健康方面可以监测血氧，还支持心电图。运动方面配备了水温传感器和深度计，可以支持浮浅。
另外它的屏幕尺寸更大一些，更薄，亮度更高，还有广视角。材质有钛金属表款可选。续航也更长一些，可以达到24小时
而SE也支持大多数的健康、运动和日常通讯等功能，像心率监测、睡眠、各种运动数据监测、打电话和收发信息等。
您可以根据自己的需要进行选择。', '血氧/心电图/水温传感器/深度计/亮度/广视角/续航/睡眠', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0151', ' Watch销售话术系列', '解答常见问题', '蜂窝网络版本 Apple Watch 有什么好处
(202303)', 1, 0, '这个蜂窝网络版有什么不一样吗?', '蜂窝网络版的 AppleWatch，可以独立的通信，即使手机不在身边或者没电了，也能接打电话，收发信息和微信。
比如您在运动的时候，手机就可以不带在身上了，更轻便。', '独立/电话/信息/微信/运动', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0152', ' Watch销售话术系列', '解答常见问题', '蜂窝网络版本 Apple Watch 有什么好处
(202303)', 2, 1, '怎么开通啊?需要办新卡吗?', '不用办卡，不换号，在线就能办理。只需要在 Watch app 上简单操作一下，就可以开通了，非常方便。我可以帮您搞定。', '', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0153', '配件和服务销售话术系列', '推荐配件', '有哪些 iPhone 的配件可以推荐（202305）', 1, 0, '场景
顾客新购买了一台 iPhone，你准备向他推荐一些配件，介绍一下~
你刚才说的配件，都有什么?', '比如充电方面，可以选原厂 20 瓦的快充头或者 MagSafe 无线充电，更安全更方便。另外您也可以考虑一下原厂的保护壳，和 iPhone 更贴合，也更耐用。如果您想配个耳机，可以选择AirPods 或者 Beats 系列。您对哪个感兴趣，我给您详细介绍一下。', '快充/无线充电/保护壳/耳机', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0154', '配件和服务销售话术系列', '推荐配件', 'HomePod 音质出色，智能体验（202305）', 1, 0, '场景
一位顾客在 HomePod 展台停下了脚步...
这个音响效果怎么样?', 'HomePod 的音质很不错。
它支持基于杜比全景声的空间音频，带来沉浸式的环绕立体声效果，就像在电影院一样。而且它可以根据摆放位置和房间形状计算，让每个角落都能听到高保真音质。
另外，您还可以通过它来呼叫 Siri 和控制智能家居。比如，可以直接问它室内的温度和湿度。', '杜比全景声/空间音频/高保真/智能家居/温度/湿度', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0155', '配件和服务销售话术系列', '推荐配件', 'iPad 的最佳搭档 Apple Pencil Pro（202405）', 1, 0, '这个 Apple Pencil Pro 你再详细介绍一下？', '全新的 Apple Pencil Pro 有了轻捏、侧旋、触觉反馈等先进功能，记笔记、绘画创作都变得更直观，用起来真的很顺手。
同时它还有 Apple Pencil 一直以来的好用功能，比如：像素级精准度，延迟超低，并可感应运笔的倾斜角度。悬停功能，让您落笔前就能看到效果。切换工具只要轻点两下笔身就可以了。磁吸充电，携带也方便。', '轻捏/侧旋/触觉反馈/像素级/倾斜角度/悬停', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0156', '配件和服务销售话术系列', '推荐配件', 'AirPods 4 全新升级，智能享听（202409）', 1, 0, '这个是 AirPods 4 吧，有什么特点?', '首先，AirPods 4 佩戴非常舒适，还新增了主动降噪款，可以减少日常生活中烦人的噪音。
使用起来也变得更加智能！比如，您只需轻轻点头就能接听电话，摇头就可以挂断。主动降噪款还配备了对话感知功能，当您与人交流时，音乐音量会自动调低，不用担心错过重要内容。
另外，它搭载了强大的 H2芯片，通话更清晰，音质更出色。
还支持头部追踪的个性化空间音频，不管是听音乐还是看电影，都能带给您身临其境的听觉享受。
最棒的是，搭配充电盒续航时间长达30小时，一整天都不用担心电量问题。
要不要试戴一下，感受一下它的音质和舒适度？', '主动降噪/对话感知/芯片/个性化空间音频', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0157', '配件和服务销售话术系列', '推荐配件', '向顾客介绍 Beats Solo 4 的主要特点(202507)', 1, 0, '这款耳机怎么样？', 'Solo 4 比上一代有很大升级，无论是音质、设计，还是续航都给你全新的体验。
增大的驱动单元和支持头部追踪的个性化空间音频功能，带给您身临其境的体验。
全新的材料和钢制铰链，戴上去就很舒服。
电池续航长达50小时，怎么用都足够；快充技术让您充电10分钟，播放5小时；听无损音频或者打游戏时，用3.5毫米接口，再也不用担心电量。
您试戴感受一下吧。', '音质/设计/续航/头部追踪/个性化空间音频/无损音频', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0158', '配件和服务销售话术系列', '推荐配件', '向顾客介绍 Beats Solo Buds 的主要特点(202507)', 1, 0, '这款耳机有什么优点？', 'Beats Solo Buds 小巧又超值，优点多多，是您随身好搭档。
搭配史上最小的 Beats 便携盒，方便随身携带；每只耳塞的通风孔能降低压力，戴起来超舒服。
定制的声效系统，双层驱动单元打造高保真音效，让您听到清晰温暖的声音。
续航最长可达 18 小时，听一整天都没问题；
你试戴感受一下', '最小/通风孔/ 声效系统/续航', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0159', '配件和服务销售话术系列', '推荐配件', '向顾客介绍 Beats Pill 的主要特点(202507)', 1, 0, '这个小音箱怎么样？', 'Beats Pill 功率强劲，设计轻巧，方便携带。它低音浑厚，高音清脆，中音也丰满，让您尽享出色音质的音乐。
向上倾斜20度的流线设计。有助于将声波传入您的耳朵；便携挂绳，方便您随身携带；内部密封也增强了，泳池边或海滩上使用，它都能很好的抵御灰尘和水的侵入。续航最长可达 24 小时，还能为您的手机充电。
你可以试听感受一下。', '功率/设计/低音 /高音 /中音/密封/续航', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0160', '配件和服务销售话术系列', '推荐配件', '向顾客介绍 PowerBeats Pro 2 的主要特点(202511)', 1, 0, '场景
你发现顾客喜欢运动时佩戴耳机, 可以向他们推荐Powerbeats Pro 2
- 这款产品有什么特点？', 'Powerbeats Pro 2 性能很强, 比上一代提升很大：
首先, 戴得超稳：经过上千运动员长时间测试, 剧烈运动也不掉。新增第五种耳塞, 更舒服。
其次, 精准测心率：这是首款支持这功能的, 实时数据帮你优化训练, 提升效果。
然后, 续航不用担心：总续航45小时, 单次能用10小时, 快充5分钟就能听一个半小时。
还有H2芯片、抗汗抗水、麦克风也优化了….您戴一下试试, 感受很明显的!', '五种/心率/续航 /45/10/5/抗汗抗水', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0161', '配件和服务销售话术系列', '推荐配件', '向顾客介绍 Beats
Studio Pro 的主要特点 (202511)', 1, 0, '场景
你发现顾客很关心耳机带来的音乐品质, 可以向他们推荐 Beats Studio Pro
- 这款产品有什么特点？', 'Beats Studio Pro 这款头戴耳机, 音质超棒, 戴着也舒服, 有以下特点：
第一是佩戴超舒适：耳罩采用一体化皮革材质, 特别柔软, 舒适贴合, 戴一整天都不累不压耳, 还经久耐用。
第二是自适应主动降噪功能：它能持续监测周围噪音, 自动调整降噪强度, 让你完全沉浸音乐。插线连接还能听无损音质。
第三是续航能力强：一次充电能用40小时。没电时快充10分钟, 就能再听4小时, 非常方便。
最后是音质很出色：40毫米驱动单元配合先进设计, 声音饱满均衡, 几乎听不到失真。您可以实际戴上试试, 效果特别明显!', '一体化/自适应主动降噪/无损/续航/40/10/4', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0162', '配件和服务销售话术系列', '推荐配件', '向顾客介绍 Beats Powerbeats Fit 的主要特点（202511）', 1, 0, '场景
你发现顾客工作和生活中经常佩戴耳机, 可以向他们推荐 Powerbeats Fit
- 这款产品有什么特点？', 'Powerbeats Fit 这耳机, 工作运动都能带起节奏! 有以下主要特点：
第一是戴得特稳特舒服：通用尺寸的耳翼, 扣在耳朵上很轻柔, 很稳固, 戴一天都舒服。充电盒也小巧, 方便携带。
第二是智能降噪, 一键通透：它的主动降噪会根据环境自动调节, 隔绝噪音。轻按一下就能开启通透模式, 随时听到周围声音。
第三是电量足, 充得快：总续航30小时, 每只耳机单次能用7小时。快充5分钟, 就能再听1小时, 很方便。&还有自定义按键、抗汗抗水、优化的麦克风.…您试戴一下感受感受!', '通用尺寸/主动降噪/通透模式/30/7/5/抗汗抗水', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0163', '配件和服务销售话术系列', '推荐配件', '倍加悦耳的AirPods Pro 3（202509）', 1, 0, '新出的第三代AirPods Pro有哪些提升?', '第三代 AirPods Pro音质更好，它采用新的多孔声学架构，低音更沉、音厂更广、人声更清晰，而且能非常智能的根据你的耳型、佩戴贴合度和聆听习惯，打造适合你的声音效果。
除此之外还有四个方面的提升：
首先，降噪提升至上一代的两倍，比第一代提升了四倍，可以说降噪效果飞跃式的提升了。
其次，加入了心率传感器，在运动的时候佩戴，可以监测心率和消耗的卡路里，并且直接和健身App联动。
第三，续航更长了，单次充电聆听达到8小时，比上一代提升2小时。
最后，新耳塞采用了采用内旋设计，共五种尺寸可选，带起来更稳更贴耳。
防水等级也达到了IP57，更适合运动时候佩戴。', '音质/降噪/两倍/四倍/心率传感器/心率/卡路里/续航/8小时/防水', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0164', '配件和服务销售话术系列', '推荐配件', '主动向顾客介绍新款 AirTag(202606)', 1, 0, '顾客购买主机后，或者顾客提及忘记或担心丢失物品等情况时，你可以主动向顾客推荐 AirTag，你可以这么说', 'AirTag 是苹果官方出的定位器，随手一挂。您就能轻松找到容易忘的挂件，安全可靠，非常省心！', '官方/扬声器/两倍/超宽带技术/查找', '2026-08-21', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0165', '配件和服务销售话术系列', '推荐配件', '主动向顾客介绍新款 AirTag(202606)', 2, 1, '你具体说说？', '您有没有过这种奔溃时刻呢——出门钥匙找不到了、商场找不到车？新一代 AirTag 只有纽扣大小，往钥匙上挂、车里一放，烦心事轻松解决。
比如东西在家找不到？喊一句“嘿 Siri，我的钥匙在哪儿？”它立刻想起来提醒您。这一代扬声器音量提升50%，沙发缝里、被子底下都能听的清清楚楚，最远在此前两倍的距离也能听见。
它内置的第二代超宽带技术，让精确查找范围最远可达之前的1.5倍。如果您的AirTag就在附近，打开“查找”APP，就能看到它距您有多远、该朝哪个方向走，找起重要物品更简单轻松了。', '官方/扬声器/两倍/超宽带技术/查找', '2026-08-21', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0166', '配件和服务销售话术系列', '推荐配件', '眼界全开 Studio Display（202603）', 1, 0, '场景：你看到顾客正在 Studio Display 前仔细查看，你走了过去…
这是你们新出的显示器吗，能介绍一下吗？', '这是最新的 Studio Display，采用了 27 英寸的 5K 视网膜显示屏，亮度可以达到  600尼特，支持 P3广色域。
1200万像素 Center Stage 摄像头，支持人物居中和桌上视角功能，能提供比上一代更好的图像质量和低光表现。
第三，高保真六扬声器系统支持空间音频和杜比全景声，低音表现比上一代提升30%。还有录音棚级三麦克风阵列，收音效果非常专业。
第四，它配备了两个雷雳5接口，可以提供最高120Gb/s的传输速度，还可以串联多个显示器，以及给主机供电。', '5K/600/广色域/摄像头/人物居中/六扬声器/三麦克风/接口', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0167', '配件和服务销售话术系列', '推荐配件', '眼界全开 Studio Display（202603）', 2, 1, '听起来不错，那另一款 XDR 有什么不同？', '它的显示效果更专业。XDR 显示屏采用 mini-LED背光。HDR峰值亮度最高可以达到 2000尼特，对比度达到一百万比一。
色彩方面，它是首款支持 Adobe RGB 的 Apple 显示器，适合设计师等专业领域。
它的刷新率可以达到120Hz，支持丝滑的动态效果，配合自适应同步技术，能随不同帧率精准控制画面，玩图形密集型游戏时无比流畅。', '峰值亮度/对比度/首款/刷新率/自适应同步', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0168', '配件和服务销售话术系列', '推荐配件', '声声升华的 
AirPods Max(202603)', 1, 0, '新出的 AirPods Max有哪些提升？', 'AirPods Max2 搭载了全新的H2芯片，带来一些非常实用的升级。
首先，它现在支持自适应音频、对话感知和语音凸显，让您的通话和音频体验更棒；还支持录音棚级录音和相机遥控，对做播客、录音乐或拍内容的人特别友好。
第二，主动降噪比上一代提升约1.5倍，能够有效地降低飞机引擎声或火车行驶等噪音，让你更专注听音乐、开会或休息。
第三，新加的高动态放大器让声音更清晰、低频更有力、中高频更自然，空间音频定位更准，看电影或玩游戏的沉浸感更强。
当然，佩戴依然很舒服，长时间戴也不累，续航长达20小时，完美满足您一天的使用需求。总体来说，声音、降噪、舒适度都有明显进步，您来体验一下吧！', '自适应音频/对话感知/主动降噪/高动态放大器', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0169', '配件和服务销售话术系列', '推荐服务', '向顾客推荐 AppleCare+（202305）', 1, 0, '场景在介绍产品时，顾客提到售后问题，你觉得是一个推荐 AppleCare+的机会~
你刚才说，有一个什么延保?', '是的，建议您考虑一下 AppleCare+官方延保服务，这样就可以把质保延长到两年，Mac 是三年，还有不限次数的意外损坏保修，每次只收很少的服务费，比正常维修省很多钱。而且电池和配件也在保修范围之内。另外，维修都是由 Apple 认证的技术人员提供的，完全可以放心。', '官方/两年/三年/不限次数/意外损坏/电池/配件/认证', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0170', '配件和服务销售话术系列', '推荐服务', 'Apple 的 AI 有什么不同之处？ （202406）', 1, 0, 'Apple 新发布的 AI 有什么特别之处吗？', 'Apple Intelligence 是独一无二的，将彻底改变人们使用Apple 产品的方式，提供个性化且私密安全的智能体验。
有三个方面的独特优势：
首先，它深度集成于操作系统中，将生成式模型与个人使用场景相结合，还能跨app 操作，提供真正对用户有益且个性化的智能功能。
另外，它充分运用 Apple 芯片对语言和图像的理解与创作能力，优先在设备端运行，不依赖于网络。对于更复杂的请求，才会去云端，进一步拓展智能化能力。
第三，它充分保证用户隐私安全，定义了 AI 隐私的新标准，让用户安心使用。
它将面向用户免费提供，测试版将于今年秋季推出，仅支持英语（美国）。部分功能、软件平台和其他语言支持将于明年陆续推出。', '智能/使用场景/个性化/芯片/设备端/隐私/安全', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0171', '配件和服务销售话术系列', '推荐服务', '邀请顾客免费体验 Apple Music（202408）', 1, 0, '场景
为顾客设置新购买的 Apple 产品或音箱耳机配件时，是一个向符合条件的顾客推荐 Apple Music 免费体验的好机会，你可以这样说。', 'Apple Music是苹果的音乐软件，不仅曲库全，而且音质好，如果您之前没有用过，我们可以送您三个月免费体验机会。', '免费', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0172', '配件和服务销售话术系列', '推荐服务', '邀请顾客免费体验 Apple Music（202408）', 2, 1, '和我现在用的听歌软件有什么区别？', '首先，Apple Music拥有数千万首无损中英文歌曲，还支持杜比全景声的空间音频。
其次绝对没有广告打扰，不会破坏您听歌的好心情。
我们还有家庭方案，每月只要¥17就可以全家最多六人使用，超级划算；不想用了，您可以随时取消。', '无损/杜比全景声/空间音频/广告/家庭', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0173', '配件和服务销售话术系列', '推荐服务', '主动邀请顾客立刻享受 iCloud+ 服务（202411）', 1, 0, '场景
顾客在体验产品时，你可以主动推荐iCloud+，帮助顾客立刻感受 iCloud+ 服务。', '我们现在有个iCloud+服务, 可以帮您把照片和视频安全地存储在云端, 手机本地保存缩略图, 节省您的手机空间。 
而且有了iCloud+, 相当于多了个额外的存储空间, 可以存更多的文件资料；还可以帮您自动备份, 您的聊天记录, 包括微信, 还有照片视频等也不用担心丢失了。 如果您不想用了, 也可以随时取消订阅。', '照片/视频/存储空间/自动备份/聊天记录/微信', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0174', '配件和服务销售话术系列', '推荐服务', '主动邀请顾客立刻享受 iCloud+ 服务（202411）', 2, 1, '这个挺好的，我最近正好换了新 iPhone 可以用下试试。我应该选择哪个方案呢？', '您可以从 50GB方案开始尝试, 也可以随时再升级。这些方案还可以和最多5位家人共享, 每个人的文件和信息都是保密的。', '', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0175', '配件和服务销售话术系列', '推荐服务', '主动邀请顾客立刻享受 iCloud+ 服务（202411）', 3, 1, '我应该选择哪个方案呢？', '您可以从 50GB方案开始尝试, 也可以随时再升级。这些方案还可以和最多5位家人共享, 每个人的文件和信息都是保密的。', '共享', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0176', '配件和服务销售话术系列', '推荐服务', '主动邀请顾客立刻享受 iCloud+ 服务（202411）', 4, 1, '场景 
请建议顾客用 iPhone 自带的相机 app 扫码。如果在选择方案时看到弹窗提示“付款信息为必填”, 是因为顾客尚未关联支付方式, 此时只需引导顾客完成关联支付方式即可。
提示付款信息必填是什么意思？我应该怎么样操作？', '这是因为您还没有关联支付方式, 只需要点击“继续"到下一页去“添加付款方式", 就可以完成付费订阅了。', '付款方式', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0177', '配件和服务销售话术系列', '推荐服务', '主动向顾客推荐碎屏保 with AppleCare Services
（202504）', 1, 0, '碎屏保是什么？怎么保？', '碎屏保是一款服务产品, 一年只需 399 元, 当您的手机前屏幕意外损坏时, 去 Apple直营店或官方售后维修, 每次只要 188 元服务费, 而且一年内不限维修次数。到期后还能续订, 续订后原厂保修也能延长一年!', '碎屏保/399/屏幕/续订', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0178', '配件和服务销售话术系列', '推荐服务', '主动向顾客推荐碎屏保 with AppleCare Services
（202504）', 2, 1, '我感觉用不上啊, 有点浪费钱', '其实很多情况下您都会用到的。特别是您上下班乘坐公共交通时玩手机, 因为拥挤容易把手机摔碎屏；或者您家里有小朋友或者小猫小狗,  手机意外跌落的可能性也大很多；
另外您要是在运动时带着手机, 或者习惯把手机和钥匙放在一起, 屏幕意外损坏的可能性也很高。 有了碎屏保, 您可以更安心, 拿 iPhone 16 Pro Max 为例, 如果前屏幕意外损坏, 碎屏保能帮您节省 2600 元呢。 
如果一年内您没用过屏幕维修服务, 服务到期时, 您可以在优惠价格续订、以旧换新额外补贴和无门槛 Apple 原厂配件优惠券这三个福利中任选一个。 
所以不管是否用上, 都超划算的。', '2600/三个/一个/续订/以旧换新/原厂配件', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0179', '配件和服务销售话术系列', '推荐服务', 'iPhone 隐私功能（202506）', 1, 0, '当你发现顾客拥有或打算购买 iPhone 时，提到密码太多太难记、有些 app 不想让别人看等隐私顾虑，你可以推荐iPhone 隐私功能的优势，你可以这么说', 'Apple 在设计 iPhone 时就考虑到了隐私，先进的隐私保护功能融入了我们的日常生活，既强大又简单好用。', '隐私', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0180', '配件和服务销售话术系列', '推荐服务', 'iPhone 隐私功能（202506）', 2, 1, '你能具体说说吗', '我们先说说密码 app 吧，它可以帮您管理和访问各种密码、通行密钥和验证码，之后只需刷面容 ID 就能登录。还可以用二维码轻松分享无线网络，家里有客人时，再也不用尴尬地到处找 Wi-Fi 密码了。', '密码/面容', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0181', '配件和服务销售话术系列', '推荐服务', 'iPhone 隐私功能（202506）', 3, 1, '这个不错，有时候别人会看我手机，有什么功能可以帮我保护隐私吗？', '当您需要把iPhone 屏幕给别人看时，可以锁定或隐藏应用来保护手机的敏感内容。自己用的时候，只需刷面容ID 就能解锁 App 资源库底部的“已隐藏”文件夹。', '锁定/隐藏', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0182', '配件和服务销售话术系列', '推荐服务', 'iPhone 隐私功能（202506）', 4, 1, '万一我手机丢了，里面的东西是不是就全泄漏了？', '希望您不会遇到这种损失，但万一丢了，失窃设备保护能为您的 iPhone 提供额外保障。它要求使用面容 ID 或触控ID 进行生物认证，不能用密码作为备选，这样可以防止他人进行关键的设备和 Apple 账户操作，比如更改设备密码或Apple 账户密码。这些措施能更好地保护您设备中的重要内容。', '失窃设备保护', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0183', '配件和服务销售话术系列', '推荐服务', '教育优惠- 师生同享
（202604）', 1, 0, '我可以享受教育优惠吗？', '只要您是国内高校的在读学生，不管是专科、本科还是硕士博士研究生，或者是已经在“中国教师”平台认证过的在职老师，都可以享受咱们的教育优惠。', '在读学生/在职老师/教育优惠', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0184', '配件和服务销售话术系列', '推荐服务', '教育优惠- 师生同享
（202604）', 2, 1, '买哪些产品可以享受教育优惠？', '目前咱们的教育优惠主要包含指定的 Mac 电脑、iPad 以及 AppleCare+，还有一些指定的配件。顺便提醒您一下，这些是有限购额度的：Mac 和 iPad 每人每年都可以各买1台，指定的配件每年最多能买2件。', 'Mac/iPad/配件', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0185', '配件和服务销售话术系列', '推荐服务', '教育优惠- 师生同享
（202604）', 3, 1, '可以帮我开发票吗？', '当然可以，不过因为这是针对个人的教育优惠，所以发票只能开您个人的名字的。另外，还需要麻烦您做个实名验证才能享受优惠。', '个人/实名验证', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0186', '配件和服务销售话术系列', '推荐服务', '教育优惠- 师生同享
（202604）', 4, 1, '怎么验证？', '您先在“中国教师”平台完成注册和认证；认证通过后，系统会生成一个电子工作证和二维码，您把那个提供给我们就可以啦。', '电子工作证/二维码', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0187', '配件和服务销售话术系列', '推荐服务', '更新系统，保护设备免受攻击（202604）', 1, 0, '看了最近工信部提醒苹果用户防范漏洞攻击，我还挺担心自己手机信息安全的', '您的安全防范意识非常好！安全研究人员最近发现一些恶意网页内容，对过时版本的iOS发起攻击。不过您不用担心，我们在第一时间发布了软件更新，就是为了解决相关漏洞。阻断这类攻击。如果您的iPhone软件一直保持最新状态，那么你已经获得了相应的安全保护。我可以协助您检查设备软件版本，如果需要也可以帮您升级到最新。同时建议您打开自动更新，不点陌生短信链接，下载软件尽量只走 App Store。', '软件更新/保持最新/自动更新/App Store', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0188', '配件和服务销售话术系列', '推荐服务', 'iCloud 助您出游开心又安心
（202605）', 1, 0, '场景
春日适合出游，你可以出动向顾客介绍 iCloud 如何帮助他们安心出游，你可以这么说～', '出门玩，建议您升级到iCloud+', '', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0189', '配件和服务销售话术系列', '推荐服务', 'iCloud 助您出游开心又安心
（202605）', 2, 1, '有什么用？', '首先，您的高分辨率照片和视频原片可安全存储在iCloud中，iCloud+ 提供更大的存储空间，可优化设备储存，你出游只管开心拍。它还能无缝同步：在一台设备上编辑或删除照片视频，操作会同步到你的所有设备，白天用手机拍，晚上回酒店用iPad或电脑大屏修图发朋友圈，特别方便。
另外，家里有宠物的话，iCloud+还是“看家神器”。连上摄像头，即可录制并查看端到端加密的家庭安防视频，在景区也能随时查看家里的情况，出游几天玩得开心又安心。', '高分辨率/无缝同步/加密', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0190', '配件和服务销售话术系列', '推荐服务', '向高考生和家长推荐碎屏保
（202606）', 1, 0, '碎屏保是什么？孩子能用得上吗？', '碎屏保是我们针对手机屏幕推出的一款服务产品，一年只要399元。大一新生刚开学马上就要军训，平时还要参加各种社团活动，手机经常拿在手上跑动，不小心磕碰碎屏的风险其实挺高的。有了这个保障，万一前屏幕意外摔坏了，每次维修只要188元服务费。拿这台iPhone 17 Pro Max来说，自费维修三千多，买了碎屏保能帮您省下2600多块钱呢。', '碎屏保/399/军训/前屏幕/188/2600', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0191', '配件和服务销售话术系列', '推荐服务', '向高考生和家长推荐碎屏保
（202606）', 2, 1, '万一真的把屏幕摔坏了，修起来不方便啊？', '非常方便的。孩子在学校当地，找任意一家 Apple直营店或者官方授权服务商就能直接修，地址在苹果官网上一查就有。而且在保障期内，维修是不限次数的。另外，这个碎屏保第二年还可以续约，续订后原厂保修也能延长一年，以后电池健康度如果低于80%，还能免费换电池，对于大学生来说特别划算。', '直营店/授权服务商/原厂保修', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0192', '配件和服务销售话术系列', '推荐服务', '向高考生和家长推荐碎屏保
（202606）', 3, 1, '挺好的，不过要是这一年都没摔坏过屏幕，这钱不全浪费了。', '如果这一年内都没用到屏幕维修，服务到期时，还有三选一福利。您可以选择200元以旧换新额外补贴，或者领一张100元 Apple原厂配件优惠券，要是想继续让孩子用得安心，也可以选择立减100元，以299元的优惠价续订第二年。不管用没用上，这钱您都不亏！', '以旧换新/配件/续订', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0193', '配件和服务销售话术系列', '推荐服务', '向顾客介绍 WWDC26 的更新亮点（202606）', 1, 0, '这次 WWDC 都发布了什么功能？', '本次大会发布了很多实用又炫酷的新功能。
首先，新系统更流畅，更快速。例如，iPhone和iPad上app的启动速度提升了30%，拍照后照片加载速度提升了70%，隔空投送传输速度提升了80%。而且新系统对旧机型非常友好，以手机为例，iPhone 11 及后续机型都能免费升级。
另外：外观更漂亮了。升级了 Liquid glass 效果，自带透明调节滑块，想要通透感或者传统清晰界面都能调节，自由度更高。
然后还有一些实用功能，比如调休闹钟、中文输入法的升级，AirPods自定义均衡器等等，而且加强了对儿童的安全管控。
特别说明一下，本次大会还发布了很多 Apple 智能以及新一代 Siri 相关的内容，在中国大陆地区还暂时无法使用，敬请期待。', '快速/调休闹钟/中文输入法/自定义均衡器', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0194', '配件和服务销售话术系列', '推荐服务', '向顾客介绍 Apple 播客（202607）', 1, 0, '你可以具体说说播客是干什么的', 'Apple 播客是 Apple 官方的一站式音频平台最大优势是在你的各款 Apple 设备上无缝同步，不论是在家还是出门，精彩随时开播。
这里有海量免费精选节目，涵盖故事、新闻、学习等聊不尽的话题让你越听越尽兴。对于特别喜欢的创作者还支持付费订阅，让您享受免广告、抢先听和会员专属福利。
软件操作非常简单，底部的标签页就能轻松找到热榜、管理下载，还支持精准调控音频，比如突显人声或者调节语速，非常实用。您可以打开看看有没有感兴趣的！', '播客/免费/订阅/精准调控/音频', '2020-01-01', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('zmsfqbjvo7t', '在你身边', '', 'coach是什么？', 1, 0, '你们店有1对1的私教吗？', '有的，我们店有免费的1对1私教，都是苹果认证培训过的。课程时间是30分钟，提供个性化学习。', '', '2020-01-01', 'archived');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('zmsgyht51s8', 'iPhone销售话术系列', '', 'iPhone 17 抽盲盒活动（202607）', 1, 0, '发现顾客关注 iPhone 17 时，请玩盲盒活动，你可以这样说...', '现在入手 iPhone 17 挺划算的，因为不仅能用国补和以旧换新抵扣，店里还送一次抽热门盲盒的机会！里面有52Toys和TNTSPACE人气潮玩。两边优惠能一起享受，特别合适。', 'iPhone/17/国补/以旧换新/优惠/盲盒/两周', '2026-08-06', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('zmsgyht5173-1', 'iPhone销售话术系列', '', 'iPhone 17 抽盲盒活动（202607）', 2, 1, '只有买 iPhone 17才能参加吗？麻烦吗？', '是的，这个盲盒惊喜只针对咱们 iPhone 17 的顾客。因为活动只有两周时间, 盲盒发完就没了， 所以我特别建议您今天就在店里拿走, 结完账我直接带您抽盲盒！', 'iPhone/17/国补/以旧换新/优惠/盲盒/两周', '2026-08-06', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0195', '配件和服务销售话术系列', '推荐服务', '向顾客介绍 iCloud 自动备份和云盘（202608）', 1, 0, '暑期是学生返校选购产品的旺季，当顾客看新机，或者询问“数据怎么办”时，你可以主动向顾客介绍 iCloud 自动备份以及 iCloud 云盘，你可以这么说…', '其实 iCloud 特别好用，主打一个省心—— 尤其是自动备份和云盘这两个功能。', '自动备份/照片/文件/通讯录/聊天记录/设置/Apple/账户/云盘/链接', '2026-08-21', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0196', '配件和服务销售话术系列', '推荐服务', '向顾客介绍 iCloud 自动备份和云盘（202608）', 2, 1, '自动备份到底怎么运作的，操作麻烦吗？', '完全不麻烦！只要手机连上Wi-Fi、充着电、锁上屏，它就会在后台自动备份您的设备，无需手动操作，方便又安全。设置新机时利用 iCloud 云备份，照片、文件、通讯录、聊天记录和常用App设置等等通通归位，省心又踏实！', '自动备份/照片/文件/通讯录/聊天记录/设置/Apple/账户/云盘/链接', '2026-08-21', 'active');
INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('0197', '配件和服务销售话术系列', '推荐服务', '向顾客介绍 iCloud 自动备份和云盘（202608）', 3, 1, '那 iCloud 云盘又是用来干嘛的？', '用同一个 Apple 账户登陆自己的多个设备，iCloud 跨设备同步能让你方便地修改、编辑和删除文件。电脑上改完文档，手机和平板拿起来看就是最新的。
iCloud 云盘让你方便和他人协作，给 iCloud 用户发大文件直接甩个链接就行，还能管理他人是否能查看、分享或编辑内容。而你也能当场看到他们作出的编辑。', '自动备份/照片/文件/通讯录/聊天记录/设置/Apple/账户/云盘/链接', '2026-08-21', 'active');

-- ====================
-- 导入演示 (DEMO_DATA)
-- ====================
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo1', 'iPhone演示系列', 'Center Stage 前摄 - 自拍合照更智能（2509）', 'active', 'iPhone 17', '图片', '开场白
iPhone 17 系列的 Center Stage 前置摄像头带来了几项实用功能, 让自拍、合影、视频通话体验更好。
拍照人物居中
当你自拍或合照时, 遇到朋友入镜, 无需转动 iPhone, 前置摄像头会自动调整构图, 把所有人都收进画面。
视频同步双拍
支持前后镜头同时录影, 也就是说你可以同时录你自己和你眼前的场景, 特别适合记录旅行vlog或录制演唱会。
视频超稳防抖
有了这个功能, 当你快走或小跑时, 自拍也很稳, 甚至可以记录 4K 60帧的杜比视界视频。
视频通话中的人物居中
在 FaceTime 或支持这个功能的App通话时, Center Stage 会自动跟随你的移动, 让你始终保持在画面中央, 就算你动一动, 也不会“跑偏”。', '["assets/demo/demo1/img1.jpg", "assets/demo/demo1/img2.jpg", "assets/demo/demo1/img3.jpg", "assets/demo/demo1/img4.jpg", "assets/demo/demo1/img5.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo2', 'iPhone演示系列', 'iPhone 17 显示屏 - 坚固又好用（2509）', 'active', 'iPhone 17', '图片', '高亮
亮度是它另一大卖点。在户外强光下, 你依旧能看清屏幕内容, 因为峰值亮度能冲到3000尼特。还有反光降低了大约 33%, 减少刺眼反射, 看地图或导航时更安心。
超瓷晶面板 2
耐用性也没含糊。正面用的是超瓷晶面板 2, 抗刮能力提升至原来的三倍。换句话说, 像钥匙拉链这样的摩擦或日常小磕碰, 屏幕更不容易留下痕迹。
结束语
这次 iPhone 17 的屏幕边框也变得更窄，拿在手里也更高级，您来试试吧。', '["assets/demo/demo2/img1.jpg", "assets/demo/demo2/img2.jpg", "assets/demo/demo2/img3.jpg", "assets/demo/demo2/img4.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo3', 'iPhone演示系列', '4800万融合式摄像头-细节满满超清晰（2509）', 'active', 'iPhone 17', '图片', '开场白
这次 iPhone 17 全系列都配备了融合式摄像头。

iPhone 17 摄像头
iPhone 17 的后置摄像头全都升级到了4800 万像素, 能实现从 0.5倍到 2倍的变焦范围, 构图更加灵活。尤其还能拍摄 4800万像素的超广角和微距照片, 细节丰富, 栩栩如生。

iPhone 17  Pro 摄像头
iPhone 17 Pro 相比iPhone 17多了一颗 4倍长焦镜头, 能进一步拉进拍摄主体, 而光学品质的8倍长焦更是iPhone迄今最长的长焦。从0.5倍超广角到8倍长焦, Pro 无所不能。

结束语
有了融合式摄像头，想怎么拍就怎么拍。', '["assets/demo/demo3/img1.jpg", "assets/demo/demo3/img3.jpg", "assets/demo/demo3/img4.jpg", "assets/demo/demo3/img2.jpg", "assets/demo/demo3/img6.jpg", "assets/demo/demo3/img5.jpg", "assets/demo/demo3/img7.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo4', 'iPhone演示系列', '别再将就旧手机！iPhone 17 系列升级对比（2509）', 'active', 'iPhone 17', '图片', '开场白
为什么说 iPhone 17 Pro 非常值得购买，拿您手上的 iPhone 13 做个简单对比，您就明白了。
屏幕优势
首先是屏幕。iPhone 17 Pro 配备全新的超视网膜 XDR 显示屏，更亮、更坚固耐用，在阳光下依然清晰可见，看视频和刷内容也更沉浸。
芯片优势
性能上，iPhone 17 Pro 搭载 A19 Pro 芯片，运算和图形能力相比 iPhone 13 的 A15 芯片提速 50%。如果是大型游戏、视频剪辑等。差距会更加明显。
摄像头优势
在拍摄方面，iPhone 17 Pro 的全新 4800 万像素 Pro 级融合式摄像头系统，不仅可以进行 8 倍光学变焦拍摄，夜景模式和人像效果更是提升显著。
电池
续航也更给力，视频播放可达 31 小时。再加上 USB-C 接口，充电和数据传输都更方便、更快。
结束语
从 iPhone 13 升级到 iPhone 17 Pro，您能感受到的就是更亮更坚固的屏幕、更强的处理器、更出色的照片，以及更安心的续航。现在换机，正是时候。', '["assets/demo/demo4/img1.jpg", "assets/demo/demo4/img2.jpg", "assets/demo/demo4/img3.jpg", "assets/demo/demo4/img4.jpg", "assets/demo/demo4/img5.jpg", "assets/demo/demo4/img6.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo5', 'iPhone演示系列', 'iPhone 17 iOS - 实用又精彩的功能（202510）', 'active', 'iPhone 17', '图片', '开场白
iOS 实用功能非常多，我跟您说几个。
演示 app 图标样式
桌面上的 app 不光能任意排列, 还能更改图标样式和大小。尤其是iOS 26 中全新的透明风格, 晶莹剔透, 高级感拉满。
演示 3D 效果锁定屏幕
您还可以将喜欢的照片作为墙纸, 并生成空间场景, 这样每次拿起手机, 您都能看到 3D效果的墙纸, 超级炫酷。配合 iOS 26全新 Liquid Glass 设计, 锁定屏幕更生动。
演示 app 加密和隐藏
Apple 向来注重隐私保护, 按住 app 会出现加密或隐藏选项, 可以设置密码或面容才能打开 app。
演示控制中心自定义
再看看控制中心, 包括收藏、媒体播放、家庭 app 的控制和接入设置, 你还可以添加更多控制内容, 版面也都可以调整大小和顺序, 满足您的不同需求。', '["assets/demo/demo5/img1.jpg", "assets/demo/demo5/img2.jpg", "assets/demo/demo5/img3.jpg", "assets/demo/demo5/img4.jpg", "assets/demo/demo5/img5.jpg", "assets/demo/demo5/img6.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo6', 'iPhone演示系列', 'iPhone 17 专业摄影-人人都是大导演（2510）', 'active', 'iPhone 17', '图片', '展示 4K 120 视频，强调拍摄后调整
iPhone 17 Pro 可以拍摄4K 120帧视频, 而且是杜比视界格式。比如这段视频, 将播放速度放慢到 24 帧每秒, 秒变大片儿。这个功能特点就是, 越是动起来的场景, 拍出来越酷, 孩子玩儿、小狗跑、还有放烟花之类的都行。

播放视频展示录音棚级四麦克风
iPhone 17 Pro 有4个录音棚级别麦克风, 效果好, 品质高。还有风噪降低功能, 环境越嘈杂, 降噪越明显。

三种混音选项展示，用素材展示
录完的视频, 还可以重新选择混音效果, 选择取景框内, 只收画面内的人声, 不收画外人声；选择录音室, 听起来就像在有隔音墙的棚里, 隔绝嘈杂；选择电影效果, 会把周围所有声音录下, 包括环境和人声, 特别具有临场感。iPhone 17 Pro 也是首款支持 ProRes RAW 和 Genlock 的iPhone, 要知道, 这种视频拍摄功能通常只有专业级别的设备才会有。', '["assets/demo/demo6/img1.jpg", "assets/demo/demo6/img2.jpg", "assets/demo/demo6/img3.jpg", "assets/demo/demo6/img4.jpg", "assets/demo/demo6/img5.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo7', 'iPhone演示系列', 'iPhone 17 摄影风格-调出你的美（2510）', 'active', 'iPhone 17', '图片', '开场白
iPhone 17 系列的摄影风格，让您轻松方便的调整色彩、高光和阴影。

打开摄影风格
比如这张人物照片，点一下调整图标，进入摄影风格页面。轻轻滑一滑这个小方块，大片的感觉就来了。

如何调氛围
您要是调人物肤色，那就看看左边这些。想要网上很火的粉嫩柔和风，建议试试全新的“珠光”摄影风格，除了肤色好看，跟环境也不违和。而右边这些呢，更注重氛围，比如，想要梦幻一些的。可以试试「缥缈」，整体对比下来的同时，还不失真。

演示控制板
咱再看这个控制板小方块儿，往右就是色彩鲜艳一点，往左就是淡一点；往上就更明亮一些，往下对比就更强烈一些。如果您对之前的效果不满意，直接点右上角的更多选项，随时都能恢复到原始状态。', '["assets/demo/demo7/img1.jpg", "assets/demo/demo7/img2.jpg", "assets/demo/demo7/img3.jpg", "assets/demo/demo7/img4.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo8', 'iPhone演示系列', 'iPhone 17 照片 App 真好用（2512）', 'active', 'iPhone 17', '图片', '调整人像照片
iPhone 17 的人像功能非常强大，简单两步，就能调节景深，获得一张背景虚化的人像照片。
调整画面焦点
人像照片还可以轻松调整焦点，点谁，谁就是照片的主角。
演示空间场景照片
还有更神奇的，打开空间场景，照片秒变“3D”效果，转动一下 iPhone，照片一下子就“活”起来了。', '["assets/demo/demo8/img1.jpg", "assets/demo/demo8/img2.jpg", "assets/demo/demo8/img3.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo9', 'iPhone演示系列', 'iPhone 17 相机控制（2512）', 'active', 'iPhone 17', '图片', '演示秒拍照片和视频
相机控制按钮，只要按一下就能开启，尤其是在拍孩子和宠物的时候，长按还能录视频。
演示打开控制选项
您还可以在设置中找到相机，选择相机控制，打开相机调整，这样您拍照时想拍的近点，轻点相机控制按钮就能看到变焦选项了，一滑，就能调成2倍变焦。
演示调整参数
如果您对摄影有更多要求，还可以进一步调整曝光、景深、摄影风格等参数，轻按两下，控制选项就出来了，您来试试看吧。', '["assets/demo/demo9/img1.jpg", "assets/demo/demo9/img2.jpg", "assets/demo/demo9/img3.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo10', 'iPhone演示系列', 'iPhone 17 灵动岛（2512）', 'active', 'iPhone 17', '图片', '开场白
灵动岛很实用，不用退出正在使用的App，就能实时看到重要的提醒、通知和活动。
灵动岛交互
比如您在听歌，当回到主屏幕时，音乐就进入了灵动岛，这就是大家常说的上岛了。再点一下这里就回去了，很方便。
两个 app 同时显示
你还可以同时让两个App在灵动岛中显示，比如边听音乐跟做饭时，你可以再打开一个计时器，再次回到主屏幕时，就能在灵动岛中看到两个App的状态了，想看哪个点哪个。
第三方 app 支持
除了这些，像是打车位置，外卖进度，出行列车，甚至航班状态都能上岛。', '["assets/demo/demo10/img1.jpg", "assets/demo/demo10/img2.jpg", "assets/demo/demo10/img3.jpg", "assets/demo/demo10/img4.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo11', 'iPhone演示系列', 'iPhone 17 操作按钮（2512）', 'active', 'iPhone 17', '图片', '开场白
操作按钮让一些常用功能操作变得更加方便，长按就能打开各种功能。
演示操作按钮
默认状态下按住操作按钮，你可以切换铃声或者静音。
演示语音备忘录
上课和开会的时候要录音，您就可以把它设置为语音备忘录，只需要按住操作按钮，马上就开始录音。
演示翻译
再比如，出国旅游的时候，您就把它设置成翻译，去哪个国家就设置成哪个国家的语言，问个路啊、点个菜啊，立刻就翻译出来了，相当不错。', '["assets/demo/demo11/img1.jpg", "assets/demo/demo11/img2.jpg", "assets/demo/demo11/img3.jpg", "assets/demo/demo11/img4.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo12', 'Apple Watch演示系列', 'Apple Watch 助你好睡眠（2509）', 'active', 'Apple Watch', '图片', '开场白
有好睡眠才有好身体, 我给您看看 Apple Watch 是如何帮助你了解自己的睡眠情况的。
演示睡眠 app
打开睡眠, 你能看到睡眠评分, 它是基于睡眠时长、就寝时间和中断次数来评估的, 这样就能大致了解自己的睡眠质量, 看看如何改善睡眠、恢复活力。各个睡眠阶段情况, 包括清醒时间、快速动眼睡眠、核心睡眠和深度睡眠。还有过去 14 天的汇总都在这儿。
演示生命体征 app
Apple Watch 不仅能告诉你是否睡得好, 还能告诉你是否健康。生命体征 app 可以监测和汇总各种健康数据, 如果某项指标出现异常, 马上就会提醒您注意。内容包括：心率、呼吸频率、手腕温度、血氧和睡眠时长。
结束语
有了 Apple Watch，时刻都能照看好你的健康。', '["assets/demo/demo12/img1.jpg", "assets/demo/demo12/img2.jpg", "assets/demo/demo12/img3.jpg", "assets/demo/demo12/img4.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo13', 'Apple Watch演示系列', 'Apple Watch 体能训练（2510）', 'active', 'Apple Watch', '图片', '开场白
Apple Watch 就像您手腕上的健身教练。

演示体能训练 app
比如，打开体能训练app，有单车、游泳、徒步、瑜伽，您喜欢什么运动，基本都能找到。全新的界面中新增了四个角落按钮，让你可以更快调取常用功能。

演示户外跑步
打开户外跑步，您就可以在表盘上看到当前的心率、滚动公里、平均配速和距离数据，甚至还能监测专业数据，像心率区间、分段的跑步表现、爬升高度等。

演示水深 app
Apple Watch Series 11 配备了深度计和水温传感器，适合浮潜。您可以在水下查看时间、当前深度、水温、水下持续时间和最大深度，默认是在水中自动打开，非常方便。', '["assets/demo/demo13/img1.jpg", "assets/demo/demo13/img2.jpg", "assets/demo/demo13/img3.jpg", "assets/demo/demo13/img4.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo14', 'Apple Watch演示系列', 'Apple Watch 日常生活更轻松（2510）', 'active', 'Apple Watch', '图片', '开场白
Apple Watch 在日常生活中非常有用。

演示语音备忘录
工作学习中，需要录音，无需iPhone，用 Apple Watch 打开语音备忘录，就能随时记录，非常方便。

演示钱包 app
买东西的时候，按两下侧边按钮，选择卡片，靠近读卡器就搞定了。坐公交地铁也是一样，用 Apple Watch 靠近闸机，“叮”的一声就刷过了。

演示翻译 app
出国旅行需要翻译，点击小话筒，直接说就能翻译，支持20多种语言，提前下载语言包，关键时刻还能离线翻。

5G 体验
Apple Watch Series 11 现在还支持 5G 网络，不仅覆盖表现更好，下载 app 或用音乐听歌，速度也更快。

总结
Apple Watch 还有很多这样的小功能，比如导航、听歌换曲等等，都非常好用。', '["assets/demo/demo14/img1.jpg", "assets/demo/demo14/img2.jpg", "assets/demo/demo14/img3.jpg", "assets/demo/demo14/img4.jpg", "assets/demo/demo14/img5.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo15', 'Apple Watch演示系列', 'Apple Watch 心率血氧（2512）', 'active', 'Apple Watch', '图片', '开场白
Apple Watch 可以检测心率和血氧，有异常时还会发出提醒。

演示心率
打开心率，很快就能测量目前数值，向下滚动，还可以看到相关数据，比如心率范围、静息心率和各种运动心率等等。

演示血氧
测量血氧也非常简单，打开血氧，保持手腕平稳15秒就行了，正常范围是90%～100%。Apple Watch会在后台监测您的血氧和心率，当出现异常时都会提醒您。

结束语
现在生活压力都比较大，关注一下心率和血氧，还是很有必要的。', '["assets/demo/demo15/img1.jpg", "assets/demo/demo15/img2.jpg", "assets/demo/demo15/img3.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo16', 'Apple Watch演示系列', 'Apple Watch 守护心理健康（2512）', 'active', 'Apple Watch', '图片', '开场白
现代人生活节奏都很快，正念app中的心理状态、沉思和呼吸可以帮助您缓解压力，调节心情。

演示正念 app
当压力比较大或者不开心的时候，你可以利用呼吸功能，跟着手腕的震动和画面中花朵的开合，有节奏的进行深呼吸。一两分钟就可以感觉更轻松，非常有效。

演示紧急呼叫、摔倒检测、车祸检测
Apple Watch 还能保护您的人身安全，更快速地进行紧急呼叫，也可以智能判断是否发生了严重摔倒或车祸情况，并自动拨打急救电话，同时将位置发送给紧急联系人。有些顾客就是出于这几点，给家人购买了 Apple Watch。

演示噪音、用药
另外，Apple Watch 还有更多健康功能，比如 “噪声”App 可以监测周围的噪音分贝“用药”App可以提醒您在什么时间服用什么药物以及服用剂量等等。', '["assets/demo/demo16/img1.jpg", "assets/demo/demo16/img2.jpg", "assets/demo/demo16/img3.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo17', 'Apple Watch演示系列', 'Apple Watch健身记录（2512）', 'active', 'Apple Watch', '图片', '开场白
Apple Watch可以非常智能的督促您少坐、多动、常锻炼。

演示健身记录 app
红色的活动圆环记录您的动态卡路里，日常步行、上下楼梯这些都算；绿色的锻炼圆环记录，有一定强度的锻炼，比如去健身房、户外快 三个圆环都闭合了，就代表您今天的目标完成了。

演示奖章
点击奖章图标，能看到所有成就，激励自己坚持运动。', '["assets/demo/demo17/img1.jpg", "assets/demo/demo17/img2.jpg", "assets/demo/demo17/img3.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo18', 'Apple Watch演示系列', 'Apple Watch 不错过重要电话信息（2512）', 'active', 'Apple Watch', '图片', '开场白
Apple Watch 可以防止错过这样的电话和信息。

演示电话 app
来电话了，Apple Watch会提示点一下就接了，拨打电话也不用掏手机在Apple Watch上直接拨号就行。

演示信息 app
回信息很容易，可以将语音转成文字再发送，还可以像这样用键盘或手写回复，微信也行。

演示双指互点两下
您还可以试试双指互点两下来接电话，像这样捏两下就行。平时在时间界面，还能切换智能堆叠，重要的事儿，一下就看见了。

结束语
不光电话信息，新闻，日历这些提醒也能在 Apple Watch上推送很方便。', '["assets/demo/demo18/img1.jpg", "assets/demo/demo18/img2.jpg", "assets/demo/demo18/img3.jpg", "assets/demo/demo18/img4.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo19', 'iPad演示系列', '为顾客演示 eSIM 版 iPad', 'active', 'iPad', '图片', '设置
支持eSIM的iPad随时连接5G网络, 我来给您快速演示一下, 首先, 我们关闭Wi-Fi网络；然后, 在这里能看到和普通Wi-Fi版iPad不一样的地方, 那就是有中国联通的蜂窝数据, 也就意味着不需要插卡, 就能随时随地连上高速 5G 网络。

视频1
像播放高清视频这种对网络要求比较高的功能, 也会非常流畅不卡顿, 这样我们就能尽情地刷视频或是追剧了。

App Store
您看, 在高速5G网络下, 无论是办公还是下载文件或是软件, 都很流畅, 非常方便。

《无限暖暖》
另外, 对于需要一直保持在线的游戏, 自带5G网络的iPad就是非常好的选择, 不仅方便携带, 还能保持游戏不断连, 《无限暖暖》是一款开放世界游戏, 在iPad强大算力支持下, 画面非常精美, 场景也很丰富。比如在花愿镇乘坐热气球的场景, 能看到湖面波光粼粼, 地面树木的枝叶也栩栩如生, 这样的游戏体验您一定爱不释手。

中国联通App
在iPad上查询eSIM流量也非常简单, 这里就是实时的使用情况, 确保您能放心用。', '["assets/demo/demo19/img1.jpg", "assets/demo/demo19/img2.jpg", "assets/demo/demo19/img3.jpg", "assets/demo/demo19/img5.jpg", "assets/demo/demo19/img6.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo20', 'iPad演示系列', 'iPad 如何激活 eSIM 服务', 'active', 'iPad', '图片', '开场白
在iPad上开通eSIM服务很简单, 无论是使用iPad还是iPhone都能轻松办理, 主要分三步, 填写信息、身份认证、激活。

填写信息
首先下载中国联通App, 找到eSIM专区, 选择iPad, 输入iPad EID和IMEI。如果您使用iPhone来操作, 需要扫描iPad包装盒背面的EID和IMEI来录入。接下来就会看到本次活动的专属优惠礼包, 一年300 GB免费流量用。确认自己的信息准确无误后, 选一个您心仪的号码, 之后查询流量时也要使用, 所以请记住这个号码。

身份认证
接下来是身份认证, 身份证正面拍一次, 反面拍一次, 然后拍摄正面免冠照, 再进行人脸检测, 您再签个名, 就到最后一步激活了。

激活
只需片刻等待, iPad eSIM业务开通就大功告成了。如果您使用的是iPhone, 这里会出现办理成功二维码, 只需要在iPad设置中找到蜂窝数据, 扫码就可以开通了。现在, 让eSIM iPad带您随时随地畅享5G吧。', '["assets/demo/demo20/img1.jpg", "assets/demo/demo20/img2.jpg", "assets/demo/demo20/img5.jpg", "assets/demo/demo20/img7.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo21', 'iPad演示系列', 'iPad提升效率好帮手（2512）', 'active', 'iPad', '图片', '快速备忘录
iPad 方便携带, 性能还强, 能大大地提升您的效率。您随时可以用 Apple Pencil 打开快速备忘录, 记录新想法。还能调整大小和位置, 随时隐藏, 非常方便。

制作精美文稿
iPad 兼容常用的文件类型, 打开和编辑都没问题, 文稿、表格、幻灯片这些都行。尤其是幻灯片, 有40多种主题任您选。更有 100多种动画效果, 您轻点几下, 幻灯片就会与众不同。还能用 iPhone 或iPad当遥控器控制演示, 专业又方便。

分屏浏览
让您充分利用iPad 的屏幕, 提升效率。比如您一边浏览网页, 一边使用备忘录记录信息, 只要这样简单拖放就搞定了。iPad 可以从照片中识别物体并单独提取, 再放到信息里, 和朋友聊天就更有趣。切换窗口也简单方便, 效率直线上升。', '["assets/demo/demo21/img1.jpg", "assets/demo/demo21/img3.jpg", "assets/demo/demo21/img5.jpg", "assets/demo/demo21/img7.jpg", "assets/demo/demo21/img8.jpg", "assets/demo/demo21/img9.jpg", "assets/demo/demo21/img10.jpg", "assets/demo/demo21/img11.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo22', 'iPad演示系列', 'iPad Pro 性能出类拔萃（2512）', 'active', 'iPad', '图片', '开场
iPad Pro 特别轻薄，加上最新的 M5 芯片，性能强得很。

设计
这是设计软件 SketchUp, 3D建模丝滑流畅，移动、旋转、放大一点都不卡。

剪辑
用 Final Cut Pro剪视频，能满帧跑4K，加上调色和特效，也照样流畅。

4-5 游戏&总结
再体验一下《原神》有了光追效果加持，画面栩栩如生，还有 120Hz 高刷，让你身临其境。配合游戏模式，能长时间保持高帧率。有了M5 芯片的 iPad Pro，创意娱乐都尽兴。', '["assets/demo/demo22/img1.jpg", "assets/demo/demo22/img2.jpg", "assets/demo/demo22/img4.jpg", "assets/demo/demo22/img5.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo23', 'iPad演示系列', 'iPadOS 科学计算器（2512）', 'active', 'iPad', '图片', '开场白
iPadOS 26 上的计算器特别好用，我给您演示一下。
科学计算器
点右上角就变成科学计算器。
3-4、数学笔记&方程式计算
您还可以用 iPad当解题板，公式写在上面，结果立刻就出来了，您做了修改，结果也跟着更新。 复杂的函数计算也一样，系统能识别您手写内容，还能把函数转换成图形，调整常数，图形就会跟着变化。
总结
用 iPadOS 科学计算器，轻松搞定复杂运算。', '["assets/demo/demo23/img1.jpg", "assets/demo/demo23/img2.jpg", "assets/demo/demo23/img3.jpg", "assets/demo/demo23/img4.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo24', 'iPad演示系列', 'iPadOS 实用小功能（2512）', 'active', 'iPad', '图片', '开场白
我给您介绍几个 iPadOS 小功能。

演示窗口管理
窗口功能很强大，您可以一次打开更多窗口，大小任意调整，位置也能随意摆放。

演示菜单栏
另外，新增的菜单栏让您能在app中快速找到所需的指令，只要从屏幕顶部向下轻扫，便可随时取用。

演示无边记app
还有无边记这个神器，能记录您的灵感碎片，手写、绘画或图片都可以，所见即所得。

演示屏幕使用时间
再说说屏幕使用时间，清晰记录每个app的使用时长，要是您怕哪个app太上头，设置个时间限制就行。配合屏幕建议使用距离，还能缓解视疲劳。

App Store
在 AppStore 中还有数百万的软件等您来探索，快来试试吧。', '["assets/demo/demo24/img1.jpg", "assets/demo/demo24/img2.jpg", "assets/demo/demo24/img3.jpg", "assets/demo/demo24/img4.jpg", "assets/demo/demo24/img5.jpg", "assets/demo/demo24/img7.jpg", "assets/demo/demo24/img8.jpg", "assets/demo/demo24/img9.jpg", "assets/demo/demo24/img10.jpg", "assets/demo/demo24/img11.jpg", "assets/demo/demo24/img12.jpg", "assets/demo/demo24/img14.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo25', 'iPad演示系列', 'iPad 出色的影音体验（2512）', 'active', 'iPad', '图片', '开场白
iPad Pro 提供了极致的影音娱乐体验。

屏幕
这块超精视网膜屏幕比您眼睛分辨的还精细, 显示内容清晰锐利。相册里每张照片都特别真实。比如设计师常用的 Procreate, P3广色域屏幕能让您配色更精准, 创作更尽兴。支持 120Hz 自适应刷新率让画面顺滑无比。有更高的创作需求, 您还可以用上参考模式, 让色彩还原更精准。

3-5 扬声器、娱乐app & 总结
除了屏幕, 四个扬声器也让您体验到极致音效。听音乐的时候, 声音饱满细腻, 高音通透, 低音浑厚。别忘了 App Store 上还有海量应用程序，追剧、游戏、创作，无所不能。 妥妥的一台影音娱乐神器。', '["assets/demo/demo25/img1.jpg", "assets/demo/demo25/img2.jpg", "assets/demo/demo25/img4.jpg", "assets/demo/demo25/img6.jpg", "assets/demo/demo25/img15.jpg", "assets/demo/demo25/img16.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo26', 'iPad演示系列', 'iPad 摄像头实用又安全（2512）', 'active', 'iPad', '图片', '开场白
iPad 的摄像头好用又安全。

扫描
您打开相机, 将摄像头对准文件, 轻点就能完成扫描生成 PDF。iPad Pro 有自适应原彩闪光灯, 还能避免阴影或炫光。

3-5 人物居中、小绿点、总结
人物居中功能可以让您在视频通话时，无论您怎么动都在画面中央。 使用摄像头的时候，iPad 会亮起小绿点，提示您有app正在使用摄像头，保护好隐私。您来试试吧。', '["assets/demo/demo26/img1.jpg", "assets/demo/demo26/img2.jpg", "assets/demo/demo26/img5.jpg", "assets/demo/demo26/img6.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo27', 'Mac演示系列', 'Guide（2504）', 'active', 'Mac', '图片', '开场白
Guide 可以帮助你更好的通过个性化对话, 为顾客进行演示并为其推荐合适的配件与服务。首先, 当你认为顾客对 Mac 感兴趣时, 请充分探寻顾客需求, 并告知顾客你将使用一个 app 来为他进行展示。在 Demoloop 界面轻点键盘上的 Command +Option + Shift + G 就可以打开 Guide。接下来, 根据你发掘到的顾客具体需求, 你就可以判断从Guide 中的哪里开始谈论与演示顾客感兴趣的内容。在“探索”模块中, 我们为升级或新用户提供了丰富的演示资源。当然, 你也可以从顾客感兴趣的功能或者配件与服务来展开对话。

探索模块
例如顾客拥有老款Macbook Pro 机型考虑升级, 我们就可以引领顾客在 Guide 中点击对应的模块, 这个页面中列举了该机型的主要卖点。点击右下角的探索按钮, 就可以获得该功能的介绍与效果演示。

配件与服务
介绍完顾客感兴趣的功能后，你还可以通过右上角的链接帮助顾客了解更多配件与服务计划。

配置比较
如果需要了解详细的配置信息，请点击主页右上方的“比较机型”按钮。使用下拉菜单选择机型后，即可获得主要的配置对比。 点击查看全部按钮，还可以获得详细的规格信息。

结束语
以上就是 Guide 的操作概览，希望这个工具能助你一臂之力。', '["assets/demo/demo27/img1.jpg", "assets/demo/demo27/img2.jpg", "assets/demo/demo27/img3.jpg", "assets/demo/demo27/img5.jpg", "assets/demo/demo27/img6.jpg", "assets/demo/demo27/img8.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo28', 'Mac演示系列', 'Mac 日常操作超好用（2512）', 'active', 'Mac', '图片', '截屏
我给您介绍几个 Mac的实用小技巧。想要全屏截图，就按 Command + Shift + 3。想要一部分，按下 Command + Shift + 4 就行。还有 Command + Shift + 5，可以录屏。截完的图会在屏幕右下角，直接拖拽到 app 里就能用，也可以直接打开编辑，方便又快捷。

快速查看（预览）
查看文件时，只要按下空格键就能预览，还能直接拷贝内容，加个签名也没问题，可以直接用触控板手写完成

结束语
Mac 就是这么简单好用。', '["assets/demo/demo28/img1.jpg", "assets/demo/demo28/img2.jpg", "assets/demo/demo28/img3.jpg", "assets/demo/demo28/img5.jpg", "assets/demo/demo28/img7.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo29', 'Mac演示系列', '视频编辑好帮手（2512）', 'active', 'Mac', '图片', '绿幕抠像
Final Cut Pro 特别简单好用。特效制作中常见的扣绿幕，在这里只要找到绿幕抠像器效果，拽过去就搞定。
优化光线和颜色
画面之间颜色不一致也没关系，选择好片段，点一下优化光线和颜色，一键匹配颜色。
流畅慢动作
视频变成慢动作的时候容易有卡顿，只要通过机器学习自动优化，效果就变得丝般顺滑。
对象追踪
还有个超厉害的功能——对象追踪。比如您想让花字跟着人物动，直接用跟踪器选好目标，分析完就自动完成了，效果特别棒。', '["assets/demo/demo29/img1.jpg", "assets/demo/demo29/img2.jpg", "assets/demo/demo29/img3.jpg", "assets/demo/demo29/img4.jpg", "assets/demo/demo29/img5.jpg", "assets/demo/demo29/img6.jpg", "assets/demo/demo29/img7.jpg", "assets/demo/demo29/img8.jpg", "assets/demo/demo29/img9.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo30', 'Mac演示系列', 'Mac 桌面和窗口管理简单又高效（2512）', 'active', 'Mac', '图片', '叠放
平时使用的文件多了，桌面就堆得乱糟糟。这类问题 Mac 都能轻松搞定。使用叠放功能，文件会自动按类型、日期等分组，一点堆叠就展开，整洁又好找。
多个桌面（F3）
如果同时使用很多App，四指上滑打开调度中心，窗口平铺就可以快速找到内容。还能新建多个桌面，工作生活分门别类，四指左右滑动就能轻松切换。
工作空间布局（分屏）
窗口拖到顶部，全屏模式让工作更专注。窗口拖到左右两侧就能分屏，两个应用一起上，边看资料边写笔记，效率翻倍。
结束语
Mac 的桌面和窗口管理简单又高效，您来体验一下吧。', '["assets/demo/demo30/img1.jpg", "assets/demo/demo30/img2.jpg", "assets/demo/demo30/img3.jpg", "assets/demo/demo30/img4.jpg", "assets/demo/demo30/img5.jpg", "assets/demo/demo30/img6.jpg", "assets/demo/demo30/img7.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo31', 'Mac演示系列', 'Mac 保护您的数据隐私和安全（2512）', 'active', 'Mac', '图片', '控制摄像头（指示灯）
隐私保护是 Mac 的强项，如果有 app 使用摄像头，您就会看到这个灯变成绿色，特别直观。

Safari 浏览器隐私报告
浏览网页时，隐藏干扰项目帮您把广告都藏起来，让您专心看内容。还有隐私报告，能帮您了解数据风险，同时把跟踪都挡住，上网更安心。

触控 ID
可以通过指纹来解锁设备、支付或者访问个人资料，安全又方便。

查找
电脑不小心弄丢了也别慌，通过“查找”功能，能定位和锁定，还能远程把数据都抹掉。在丢失模式里设置个联系方式，方便别人捡到后和您联系，把电脑找回来。

结束语
Mac 时刻都在保护您的隐私和安全，让您用得放心。', '["assets/demo/demo31/img1.jpg", "assets/demo/demo31/img2.jpg", "assets/demo/demo31/img4.jpg", "assets/demo/demo31/img5.jpg", "assets/demo/demo31/img6.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo32', 'Mac演示系列', 'Keynote - 幻灯片演示神器（2512）', 'active', 'Mac', '图片', '开场白
用 Mac 做汇报演讲，自带的 Keynote 非常专业。
丰富主题
这里有丰富的主题可以选择，总有一款适合您。尤其是动态背景，提供许多自定义选项，非常有视觉冲击力。
动画效果
也是 Keynote 的强项。这个“神奇移动”效果能让画面中的元素在幻灯片之间无缝过渡，特别流畅。
实时视频
实时视频模式能让您边讲解边让听众看到你，互动感也更好。
协作共享
协作功能可以让多人同时编辑、修改实时同步，省时省力。还支持 Office 格式文件，同事在 Windows 上打开也没问题。
版本功能
特别好用，如果误删了内容或者对修改不满意，点击“浏览所有版本”，历史版本立刻呈现，轻松恢复之前的内容。有了 Keynote，您的演讲就会更吸引人，您上手试试？', '["assets/demo/demo32/img1.jpg", "assets/demo/demo32/img2.jpg", "assets/demo/demo32/img3.jpg", "assets/demo/demo32/img4.jpg", "assets/demo/demo32/img5.jpg", "assets/demo/demo32/img7.jpg", "assets/demo/demo32/img6.jpg", "assets/demo/demo32/img8.jpg", "assets/demo/demo32/img9.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo33', 'Mac演示系列', 'Mac 显示器 - 极致视觉体验（2512）', 'active', 'Mac', '图片', '照片、视频
Mac 的屏幕绝对一流。您看这 MacBook Air，屏幕色彩非常鲜艳，分辨率还超高。像这张人像照片，肤色多自然，放大了细节也清晰可见。MacBook Pro 的屏幕更厉害，亮度超高。您看这段 HDR 视频，亮部和暗部的细节特清晰，非常真实。即使户外使用也没问题。
原彩显示
还有原彩显示功能，屏幕会根据光线变化自动调整色温，看着舒服，眼睛也不累。
ProMotion
ProMotion 功能也厉害，能根据屏幕内容自动调刷新率，滚动网页、看文稿都特别顺滑。
屏幕保护程序
系统自带的屏幕保护程序也值得一提，有世界各地的美景，显示出来特别惊艳。', '["assets/demo/demo33/img1.jpg", "assets/demo/demo33/img2.jpg", "assets/demo/demo33/img3.jpg", "assets/demo/demo33/img4.jpg", "assets/demo/demo33/img6.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo34', 'Mac演示系列', '有 Mac 就能玩 AI（2512）', 'active', 'Mac', '图片', '照片内容搜索
Mac里有非常多的 AI 功能，可以快速地帮您完成繁复的操作。比如找一张奶茶照片做海报，可以直接在照片里搜索“饮料”，AI 会通过内容识别快速地帮您把照片筛选出来。
物体识别
不想要后面的背景？AI 还可以自动识别照片主体，帮您把它抠出来。
文字识别
照片里的一大段奶茶制作方法，可以直接在照片里选择文字内容，外文也没关系，可以一键翻译成中文。您看，不需要使用好几个不同软件，只在照片里就可以借助 AI 快速完成工作。
其他 App
Apple芯片搭载了专门的神经网络引擎与加速器，处理复杂的 AI 功能是又快又省电。Mac 也为Apple 智能预备好，给你在写作、处理各项事务上提供协助，让一切更简单轻松。', '["assets/demo/demo34/img1.jpg", "assets/demo/demo34/img3.jpg", "assets/demo/demo34/img4.jpg", "assets/demo/demo34/img5.jpg", "assets/demo/demo34/img6.jpg", "assets/demo/demo34/img7.jpg", "assets/demo/demo34/img8.jpg", "assets/demo/demo34/img9.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo35', 'Mac演示系列', 'Mac 和 iPhone 一样容易上手（2512）', 'active', 'Mac', '图片', '开场白
Mac 电脑和 iPhone 一样简单好用。您看屏幕下方也有一条程序坞, 上面都是常用的软件。
程序坞与启动
点这个图标, 进入启动台, 看上去和 iPhone 主屏幕很像, 这是 Mac 上所有的应用程序, 还提供了智能分类帮你快速找到应用。
聚焦搜索
Mac 找东西也特别简单方便。只要点右上角放大镜图标。比如输入“旅游”就能马上找到您需要的日历项、备忘录等。再试试输入“水果”, 它还能非常智能的识别图片里的内容。不光找内容, 您还能把它当作计算器或换算工具, 比如这样进行货币兑换。很多常用的操作也不需要打开软件来完成, 例如发信息, 可以直接输入发信息, 然后根据提示输入信息内容和收件人就搞定了, 非常快捷。
结束语
Mac电脑, 上手简单, 完全不用担心。', '["assets/demo/demo35/img1.jpg", "assets/demo/demo35/img2.jpg", "assets/demo/demo35/img3.jpg", "assets/demo/demo35/img4.jpg", "assets/demo/demo35/img5.jpg", "assets/demo/demo35/img6.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo36', 'Mac演示系列', 'Mac 性能强&续航长（202512）', 'active', 'Mac', '图片', '多任务处理
Apple 芯片的 Mac 电脑，性能强劲又省电。比如您平时可能经常要同时打开多个应用程序，在窗口间快速切换。这台 Mac 完全不会卡顿，丝滑流畅。
视频剪辑
剪视频更厉害，像 Final Cut Pro 软件，同时播放多条 4K 视频依旧流畅自如。即使加入特效，也不需要等待渲染就能马上预览效果。借助强大的 AI能力，可以快速将横屏视频转成竖屏，轻轻一点，重要画面自动居中，非常省心。
电池续航
这么强大的性能却非常省电，一整天都不用担心电量，插电不插电，性能都一样出色。即便没电了，快充功能半小时就能充一半电量。
结束语
性能强、续航长，这就是 Mac 电脑。', '["assets/demo/demo36/img1.jpg", "assets/demo/demo36/img2.jpg", "assets/demo/demo36/img3.jpg", "assets/demo/demo36/img4.jpg", "assets/demo/demo36/img5.jpg", "assets/demo/demo36/img6.jpg", "assets/demo/demo36/img7.jpg", "assets/demo/demo36/img8.jpg", "assets/demo/demo36/img9.jpg", "assets/demo/demo36/img10.jpg"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo37', 'Mac + iPhone 连续互通', '学习场景（2604）', 'active', '连续互通', '图片', '开场白
很多您在 iPhone 上熟悉的 app, 无论是系统自带的照片和备忘录, 还是像微软 Office 与微信这样的第三方软件, 在 Mac上都可以使用。不但用起来和 iPhone 一样的简单易懂, 内容也是自动同步的。
同时 Apple 的产品互相之间还可以无缝协作, 操作也非常简单。现在, 我就来展示怎么把Mac 与 iPhone 搭配起来实现这些功能。比如, 您正在制作一份活动的邀请函。

通⽤剪贴板
现在需要把 iPhone ⾥的⼀张图⽚放到这个邀请函⾥, 之前, 您可能会通过数据线或者微信来发送图⽚, 操作起来⽐较繁琐。现在, 如果您使⽤ Mac 的话, 就不⽤这么麻烦了, 只需要先在 iPhone 上拷⻉⼀下这个图⽚。然后在 Mac 上找到这份邀请函, 使⽤快捷键 Command+V, 就可以快速地把图⽚粘贴进来, 完全告别之前繁琐的办法了。除了图⽚, ⽂字和链接都可以这样进⾏复制粘贴, ⾮常⽅便。

轻点两下

iPhone 镜像
另外，如果您的 iPhone 放在包里不方便快速拿取，只需在 Mac 上打开 iPhone 镜像，您就可以直接在 Mac 上访问 iPhone 上的内容了。
打开 iPhone 照片，将要添加的照片拖拽到桌面中就搞定了。

连续互通相机
我们还可以让 iPhone 相机拍摄的照片也马上出现在 Mac 上，比如我还想在邀请函里加一张手边礼物的照片，这时只需点击右键菜单里的“拍照”按钮。
iPhone 上会自动打开拍照界面，我们只用按下快门, Mac 上会立刻出现这张照片。

接力
iPhone 和 Mac 除了在一起的时候可以这样搭配使用, 即使在不同的时间和地点分开使用, 也能有像在使用同一台设备一样的神奇体验。比如我在回家的路上写发给朋友们的邀请函邮件, 到家时还剩下一些内容没有写完。
我的 Mac 会自动的在程序坞里提示 iPhone 上正在使用邮件, 这时, 我点击一下图标, 您可以看到在iPhone 上的内容已经同步显示在 Mac 上了。这样我们就可以在 Mac 的大屏幕上完成接下来的部分了。您可以在一台Apple 设备上开始工作, 然后轻松地在另一台设备上从上次中断的地方继续。无需存储草稿, 也不用进入某个特定文件夹, 整个过程无缝衔接。

结束语
Apple 设备还有很多其他的连续互通功能，可以帮您更高效的工作，比如“隔空投送”让您快速的和同事共享文件，“隔空播放”让您无线投屏到会议室的大屏幕。切换到 Mac 也非常简单，迁移助理功能可以一键转移，Windows 电脑里的文件同时在 Mac上登录 Apple 账号，您存储在 iCloud上的数据，比如照片、文件和备忘录就自动同步过来了。', '["assets/demo/demo37/img1.jpg", "assets/demo/demo37/img2.jpg", "assets/demo/demo37/img3.jpg", "assets/demo/demo37/img4.jpg", "assets/demo/demo37/img5.jpg", "assets/demo/demo37/img6.jpg", "assets/demo/demo37/img7.jpg", "assets/demo/demo37/img8.jpg", "assets/demo/demo37/img9.jpg", "assets/demo/demo37/img10.jpg", "assets/demo/demo37/img11.png"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo38', 'Mac + iPhone 连续互通', '日常生活（2604）', 'active', '连续互通', '图片', '开场白
很多您在 iPhone 上熟悉的 app, 无论是系统自带的照片和备忘录, 还是像微软 Office 与微信这样的第三方软件, 在 Mac上都可以使用。不但用起来和 iPhone 一样的简单易懂, 内容也是自动同步的。
同时 Apple 的产品互相之间还可以无缝协作, 操作也非常简单。现在, 我就来展示怎么把Mac 与 iPhone 搭配起来实现这些功能。比如, 您正在制作一份活动的邀请函。

通⽤剪贴板
现在需要把 iPhone 里的一张图片放到这个邀请函里, 之前, 您可能会通过数据线或者微信来发送图片, 操作起来比较繁琐。现在, 如果您使用 Mac 的话, 就不用这么麻烦了, 只需要先在 iPhone 上拷贝一下这个图片。然后在 Mac 上找到这份邀请函, 使用快捷键 Command+V, 就可以快速地把图片粘贴进来, 完全告别之前繁琐的办法了。

iPhone 镜像
另外，如果您的 iPhone 放在包里不方便快速拿取，只需在 Mac 上打开 iPhone 镜像，您就可以直接在 Mac 上访问 iPhone 上的内容了。
打开 iPhone 照片，将要添加的照片拖拽到桌面中就搞定了。

连续互通相机
我们还可以让 iPhone 相机拍摄的照片也马上出现在 Mac 上，比如我还想在邀请函里加一张手边礼物的照片，这时只需点击右键菜单里的“拍照”按钮。
iPhone 上会自动打开拍照界面，我们只用按下快门, Mac 上会立刻出现这张照片。

接力
iPhone 和 Mac 除了在一起的时候可以这样搭配使用, 即使在不同的时间和地点分开使用, 也能有像在使用同一台设备一样的神奇体验。比如我在回家的路上写发给朋友们的邀请函邮件, 到家时还剩下一些内容没有写完。
我的 Mac 会自动的在程序坞里提示 iPhone 上正在使用邮件, 这时, 我点击一下图标, 您可以看到在iPhone 上的内容已经同步显示在 Mac 上了。这样我们就可以在 Mac 的大屏幕上完成接下来的部分了。您可以在一台Apple 设备上开始工作, 然后轻松地在另一台设备上从上次中断的地方继续。无需存储草稿, 也不用进入某个特定文件夹, 整个过程无缝衔接。

结束语
Apple 设备还有很多其他的连续互通功能，可以帮您更高效的工作，比如“隔空投送”让您快速的和同事共享文件，“隔空播放”让您无线投屏到会议室的大屏幕。切换到 Mac 也非常简单，迁移助理功能可以一键转移，Windows 电脑里的文件同时在 Mac上登录 Apple 账号，您存储在 iCloud上的数据，比如照片、文件和备忘录就自动同步过来了。', '["assets/demo/demo38/img1.jpg", "assets/demo/demo38/img2.jpg", "assets/demo/demo38/img3.jpg", "assets/demo/demo38/img4.jpg", "assets/demo/demo38/img5.jpg", "assets/demo/demo38/img6.jpg", "assets/demo/demo38/img7.jpg", "assets/demo/demo38/img8.jpg", "assets/demo/demo38/img9.jpg", "assets/demo/demo38/img10.jpg", "assets/demo/demo38/img11.jpg", "assets/demo/demo38/img12.png"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo39', 'Mac + iPhone 连续互通', '工作场景（2604）', 'active', '连续互通', '图片', '开场白
工作中常用的软件从微软office到微信，从腾讯会议再到飞书，在Mac上都可以使用。iPhone 里的工作文件，也可以通过 iCloud 与 Mac 自动同步，同时 Apple 的产品互相之间还可以无缝协作，提高工作效率，现在，我就来展示怎么把 Mac 与 iPhone 搭配来实现这些功能。

通⽤剪贴板
就拿我们工作中使用的演示文稿，做个例子。 之前, 您可能会通过数据线或者微信来发送图片, 操作起来比较繁琐。现在, 如果您使用 Mac 的话, 就不用这么麻烦了, 只需要先在 iPhone 上拷贝一下这个图片。然后在 Mac 上找到这份邀请函, 使用快捷键 Command+V, 就可以快速地把图片粘贴进来, 完全告别之前繁琐的办法了。
除了图片，文字和链接都可以这样进行复制和粘贴，非常方便。

标记连续互通
我们在工作中有时需要为一些文件添加标注，这时我们可以以调用 iPhone 来对 Mac 上的文件进行操作，使用熟悉的 iPhone 触摸屏来进行标注，您会发现操作更加的顺手，添加好的标注会立刻显示在Mac的文件上，随写随有。

iPhone 镜像
另外，您如果有想法要记录下来，但又不方便用iPhone来操作，只要在 Mac 上打开 iPhone 镜像，您就可以直接在 Mac 上查看并快速访问iPhone 上的内容了。比如 Mac 上正在编辑备忘录，想要添加一张 iPhone 上保存的照片，直接打开 iPhone 照片，将要添加的照片拖拽到备忘录中就搞定了。在整个操作过程中，您的 iPhone 都保持着锁定状态，不用担心被他人看到。

接力
iPhone 和 Mac 除了在一起的时候可以搭配使用，即使在不同的时间和地点分开使用，也能有像在使用同一台设备一样的神奇体验。比如我在上班的路上写一封邮件，到公司时还剩下一些内容没有写完。当我打开办公桌上的 Mac 程序坞里会自动提示 iPhone 上正在使用邮件，点击一下图标，您可以看到在 iPhone 上的内容已经同步显示在 Mac 上了，这样我们就可以在 Mac 的大屏幕上完成接下来的部分了。您可以在一台 Apple 设备上开始工作，然后在另一台设备上从上次中断的地方继续。无需存储草稿，也不用进入某个特定文件夹，整个过程无缝衔接。

结束语
Apple 设备还有很多其他的连续互通功能，可以帮您更高效的工作，比如“隔空投送”让您快速的和同事共享文件，“隔空播放”让您无线投屏到会议室的大屏幕。切换到 Mac 也非常简单，迁移助理功能可以一键转移，Windows 电脑里的文件同时在 Mac上登录 Apple 账号，您存储在 iCloud上的数据，比如照片、文件和备忘录就自动同步过来了。', '["assets/demo/demo39/img1.jpg", "assets/demo/demo39/img2.jpg", "assets/demo/demo39/img3.jpg", "assets/demo/demo39/img4.jpg", "assets/demo/demo39/img5.jpg", "assets/demo/demo39/img6.jpg", "assets/demo/demo39/img7.jpg", "assets/demo/demo39/img8.jpg", "assets/demo/demo39/img9.jpg", "assets/demo/demo39/img10.jpg", "assets/demo/demo39/img11.jpg", "assets/demo/demo39/img12.png"]');
INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('demo40', '国补操作流程', '国补操作流程 - 云闪付版', 'active', '国补', '图片', '1、云闪付绑卡
您可以先扫码下载云闪付，然后绑定自己的银行卡。
2、领取国补消费券
接下来，需要您在云闪付里领取国补消费券。并在领取记录中予以确认。
3、消费券核销并支付
是您挑选的新机，我需要先扫一下您的国补消费券二维码，然后再扫一下您的云闪付付款码，就可以进行支付了。完成后，请您帮我在小票上签字。
4、货品登记
接下来我需要扫描包装盒背面的串码，在我们系统里帮您登记。
5、新机激活与上传购买凭证
再次和您确认一下新机，没问题的话，我就帮您拆封激活了。最后，我需要把新机拍照，并上传系统，然后帮您开具个人发票。这样，整个流程就结束了，感谢您的配合。', '["assets/demo/demo40/img1.jpg", "assets/demo/demo40/img2.jpg", "assets/demo/demo40/img3.jpg", "assets/demo/demo40/img4.jpg", "assets/demo/demo40/img5.jpg", "assets/demo/demo40/img6.jpg", "assets/demo/demo40/img7.jpg", "assets/demo/demo40/img8.jpg", "assets/demo/demo40/img9.jpg", "assets/demo/demo40/img10.jpg"]');
