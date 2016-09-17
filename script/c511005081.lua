--Reawakening of the Emperor
--帝王の再覚醒
--  By Shad3

local scard=c511005081

function scard.initial_effect(c)
  --Global check
  if not scard.gl_chk then
    scard.gl_chk=true
    local ge1=Effect.GlobalEffect()
    ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge1:SetCode(EVENT_CHAINING)
    ge1:SetCondition(scard.reg_cd)
    ge1:SetOperation(scard.reg_op)
    Duel.RegisterEffect(ge1,0)
    scard.ev_str={}
    scard.ch_str={}
    --clear ev_str
    local ge2=Effect.GlobalEffect()
    ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge2:SetCode(EVENT_LEAVE_FIELD)
    ge2:SetOperation(scard.clr_op)
    Duel.RegisterEffect(ge2,0)
    scard.mon_trg={4929256,9748752,15545291,23064604,26205777,51945556,57666212,60229110,69230391,65612386,69327790,85718645,87288189,87602890,96570609}
  end
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCost(scard.cs)
  e1:SetTarget(scard.tg)
  e1:SetOperation(scard.op)
  c:RegisterEffect(e1)
end

function scard.chk_mon_trg(c)
  if bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)~=SUMMON_TYPE_ADVANCE then return false end
  for _,i in ipairs(scard.mon_trg) do
    if c:IsCode(i) then return true end
  end
  return false
end

function scard.reg_cd(e,tp,eg,ep,ev,re,r,rp)
  return re:IsActiveType(TYPE_MONSTER) and re:GetCode()==EVENT_SUMMON_SUCCESS and re:GetHandler()==re:GetOwner() and scard.chk_mon_trg(re:GetHandler())
end

function scard.reg_op(e,tp,eg,ep,ev,re,r,rp)
  local tc=re:GetHandler()
  scard.ev_str[tc]=re
end

function scard.clr_op(e,tp,eg,ep,ev,re,r,rp)
  local c=eg:GetFirst()
  while c do
    if bit.band(c:GetReason(),REASON_TEMPORARY)==0 then
      if scard.ev_str[c] then scard.ev_str[c]=nil end
    end
    c=eg:GetNext()
  end
end

function scard.fil(c,e,tp)
  if bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)~=SUMMON_TYPE_ADVANCE or not c:IsFaceup() then return false end
  local te=scard.ev_str[c]
  if not te then return false end
  local targ=te:GetTarget()
  return not targ or targ(e,tp,Group.FromCards(c),tp,0,nil,0,tp,0)
end

function scard.cs(e,tp,eg,ep,ev,re,r,rp,chk)
  local g=Duel.GetMatchingGroup(scard.fil,tp,LOCATION_MZONE,0,nil,e,tp)
  if chk==0 then return g:GetCount()>0 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
  scard.ch_str[Duel.GetCurrentChain()]=scard.ev_str[g:Select(tp,1,1,nil):GetFirst()]
end

function scard.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local cn=Duel.GetCurrentChain()
  local te=scard.ch_str[cn]
  if chkc then
    if not te then return false end
    local targ=te:GetTarget()
    return targ(e,tp,eg,ep,ev,re,r,rp,0,chkc)
  end
  if chk==0 then
    e:SetCategory(0)
    e:SetProperty(0)
    e:SetLabel(0)
    e:SetLabelObject(nil)
    return true
  end
  if not te then return end
  e:SetCategory(te:GetCategory())
  e:SetProperty(te:GetProperty())
  e:SetLabel(te:GetLabel())
  e:SetLabelObject(te:GetLabelObject())
  local targ=te:GetTarget()
  if targ then
    local sg=Group.FromCards(te:GetHandler())
    if targ(e,tp,sg,tp,0,nil,0,tp,0) then
      targ(e,tp,sg,tp,0,nil,0,tp,1)
    else
      scard.ch_str[cn]=nil
    end
  end
end

function scard.op(e,tp,eg,ep,ev,re,r,rp)
  local te=scard.ch_str[Duel.GetCurrentChain()]
  if not te then return end
  local oper=te:GetOperation()
  if oper then oper(e,tp,Group.FromCards(te:GetHandler()),tp,0,nil,0,tp) end
end