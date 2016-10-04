--Galaxy Shockwave
--銀河衝撃
--  By Shad3

local function getID()
  local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
  str=string.sub(str,1,string.len(str)-4)
  local scard=_G[str]
  local s_id=tonumber(string.sub(str,2))
  return scard,s_id
end

local scard,s_id=getID()
local _str=4002

function scard.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetHintTiming(TIMING_ATTACK)
  e1:SetTarget(scard.tg)
  e1:SetOperation(scard.op)
  c:RegisterEffect(e1)
end

function scard.fil(c)
  return c:IsSetCard(0x7b) and c:IsFaceup()
end

function scard.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and scard.fil(chkc) end
  if chk==0 then return Duel.IsExistingTarget(scard.fil,tp,LOCATION_MZONE,0,1,nil) end
  local tc=Duel.SelectTarget(tp,scard.fil,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
  if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and tc:IsRelateToBattle() then
    local bc=tc:GetBattleTarget()
    if bc and tc:GetFlagEffect(s_id)==0 and bc:IsFaceup() and tc:GetAttack()==bc:GetAttack() and Duel.SelectYesNo(tp,aux.Stringid(_str,0)) then
      tc:RegisterFlagEffect(s_id,RESET_PHASE+PHASE_DAMAGE,0,0)
      e:SetLabel(1)
      e:SetLabelObject(bc)
    end
  end
end

function scard.op(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and scard.fil(tc) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(scard.bat_tg)
    e1:SetOperation(scard.bat_op)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1)
    if e:GetLabel()==1 then
      e1:SetLabelObject(e:GetLabelObject())
      scard.bat_op(e1,tp,eg,ep,ev,re,r,rp)
    end
  end
end

function scard.bat_tg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  if chk==0 then
    if not c:IsRelateToBattle() then return false end
    return bc and scard.fil(c) and c:GetFlagEffect(s_id)==0 and bc:IsFaceup() and c:GetAttack()==bc:GetAttack()
  end
  c:RegisterFlagEffect(s_id,RESET_PHASE+PHASE_DAMAGE,0,0)
  e:SetLabelObject(bc)
end

function scard.bat_op(e,tp,eg,ep,ev,re,r,rp)
  local ac=e:GetHandler()
  if not ac:IsRelateToBattle() then return false end
  local bc=ac:GetBattleTarget()
  if bc and bc==e:GetLabelObject() then
    local c=e:GetOwner()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(1500)
    e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
    ac:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE)
    e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
    bc:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_DISABLE_EFFECT)
    bc:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetCode(EFFECT_TYPE_SINGLE)
    e4:SetType(EFFECT_IMMUNE_EFFECT)
    e4:SetValue(scard.im_val)
    e4:SetReset(RESET_PHASE+PHASE_DAMAGE)
    bc:RegisterEffect(e4)
  end
end

function scard.im_val(e,re)
  return re:GetOwner()~=e:GetOwner()
end