--Gagaga Barrier
--  By Shad3

local scard=c511005079

function scard.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_CHAINING)
  e1:SetCondition(scard.cd)
  e1:SetOperation(scard.op)
  c:RegisterEffect(e1)
end

function scard.cd(e,tp,eg,ep,ev,re,r,rp)
  if rp==tp then return end
  if not (re and re:IsActiveType(TYPE_MONSTER) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and re:GetHandler():IsLocation(LOCATION_MZONE)) then return false end
  local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
  if not g or g:GetCount()~=1 then return false end
  local c=g:GetFirst()
  if c:IsOnField() and c:IsFaceup() and c:IsSetCard(0x54) then
    e:SetLabelObject(c)
    return true
  end
  return false
end

function scard.op(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  if tc:IsOnField() and tc:IsFaceup() then
    local rc=re:GetHandler()
    tc:CreateRelation(rc,RESET_EVENT+0x1fe0000)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetCondition(scard.dis_cd)
    e1:SetLabelObject(tc)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    rc:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    rc:RegisterEffect(e2)
  end
end

function scard.dis_cd(e)
  if e:GetLabelObject():IsRelateToCard(e:GetHandler()) then return true end
  e:Reset()
  return false
end