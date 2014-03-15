# -*- coding: utf-8 -*-
module XFlash
  FIXTURES = [
    [0, '入選', "(入选) [ru4 xuan3] /to be chosen/to be elected as/"],
    [1, '報名', "(报名) [bao4 ming2] /to sign up/to enter one's name/to apply/to register/to enroll/to enlist/"],
    [2, '訊息', "(讯息) [xun4 xi1] /information/news/message/text message or SMS/"],
    [3, '詢問', "(询问) [xun2 wen4] /to inquire/"],
    [4, '導致', "(导致) [dao3 zhi4] /to lead to/to create/to cause/to bring about/"],
    [5, '琴', "[qin2] /guqin or zither, cf 古琴[gu3 qin2]/musical instrument in general/"],
    [6, '提供', "[ti2 gong1] /to offer/to supply/to provide/to furnish/"],
    [7, '更新', "[geng1 xin1] /to replace the old with new/to renew/to renovate/to upgrade/to update/to regenerate/"],
    [8, '出力', "[chu1 li4] /to exert oneself/"],
    [9, '拌蒜', "[ban4 suan4] /to stagger (walk unsteadily)/"],
  ].map{|args| Card.new(*args, CardState::EMPTY)}
end
