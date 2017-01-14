--Cross Counter Trap
--クロス・カウンター・トラップ
--  By Shad3

local scard=c511005085
local s_id=511005085

function scard.initial_effect(c)
  --Activate (does nothing, just to avoid error)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(aux.FALSE)
  c:RegisterEffect(e1)
  --Allow Trap from hand
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetCondition(scard.tograve_cd)
  e2:SetOperation(scard.tograve_op)
  c:RegisterEffect(e2)
  --External register
  if not scard.gl_chk then
    scard.gl_chk=true
    scard.tcount={[0]=0,[1]=0}
    local ge1=Effect.GlobalEffect()
    ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge1:SetCode(EVENT_TURN_END)
    ge1:SetOperation(scard.rst_op)
    Duel.RegisterEffect(ge1,0)
  end
end

function scard.rst_op()
  scard.tcount[0]=0
  scard.tcount[1]=0
end

function scard.tograve_cd(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsReason(REASON_EFFECT) and rp~=tp
end

function scard.tograve_op(e,tp,eg,ep,ev,re,r,rp)
  local ct=scard.tcount[tp]
  if ct==0 then
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e1:SetTargetRange(LOCATION_HAND,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAINING)
    e2:SetOperation(scard.t_res_op)
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetLabelObject(e1)
    Duel.RegisterEffect(e2,tp)
  end
  scard.tcount[tp]=ct+1
end

function scard.t_res_op(e,tp,eg,ep,ev,re,r,rp)
  if rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and re:GetHandler():GetPreviousLocation()==LOCATION_HAND then
    scard.tcount[tp]=scard.tcount[tp]-1
    if scard.tcount[tp]==0 then
      e:GetLabelObject():Reset()
      e:Reset()
    end
  end
end