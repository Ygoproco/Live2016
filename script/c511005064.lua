--Fusion Trench
--  By Shad3

local scard=c511005064
function scard.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --Cannot Attack
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_CANNOT_ATTACK)
  e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
  e2:SetRange(LOCATION_SZONE)
  e2:SetTarget(scard.ca_tg)
  c:RegisterEffect(e2)
  --Direct Attack
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_DIRECT_ATTACK)
  e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
  e3:SetRange(LOCATION_SZONE)
  e3:SetTarget(scard.da_tg)
  c:RegisterEffect(e3)
  --Global function
  if not scard['gl_chk'] then
    scard['gl_chk']=true
    local ge1=Effect.GlobalEffect()
    ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge1:SetCode(EVENT_BATTLE_START)
    ge1:SetOperation(scard.gl_op)
    Duel.RegisterEffect(ge1,0)
  end
  --Oath
  Duel.AddCustomActivityCounter(511005064,ACTIVITY_SUMMON,scard.oath_fil)
  Duel.AddCustomActivityCounter(511005064,ACTIVITY_SPSUMMON,scard.oath_fil)
end

function scard.trap_fil(c)
  return c:IsCode(511005064) and c:IsFaceup() and c:GetFlagEffect(511005064)==0
end

function scard.gl_op(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetAttacker():IsType(TYPE_FUSION) and not Duel.GetAttackTarget() then
    local g=Duel.GetMatchingGroup(scard.trap_fil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
    if g:GetCount()>0 then
      local ac=Duel.GetAttacker()
      ac:RegisterFlagEffect(511005064,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
      if ac:IsHasEffect(EFFECT_DIRECT_ATTACK) then
        ac:ResetFlagEffect(511005064)
      else
        g:GetFirst():RegisterFlagEffect(511005064,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
        if Duel.GetFlagEffect(ac:GetControler(),511005064)==0 then
          Duel.RegisterFlagEffect(ac:GetControler(),511005064,RESET_PHASE+PHASE_END,0,0)
          local e1=Effect.CreateEffect(g:GetFirst())
          e1:SetType(EFFECT_TYPE_FIELD)
          e1:SetCode(EFFECT_CANNOT_SUMMON)
          e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
          e1:SetTargetRange(1,0)
          e1:SetTarget(scard.ca_tg)
          e1:SetReset(RESET_PHASE+PHASE_END)
          Duel.RegisterEffect(e1,ac:GetControler())
          local e2=e1:Clone()
          e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
          Duel.RegisterEffect(e2,ac:GetControler())
        end
      end
    end
  end
end

function scard.ca_tg(e,c)
  return not c:IsType(TYPE_FUSION)
end

function scard.da_tg(e,c)
  return Duel.GetCustomActivityCount(511005064,c:GetControler(),ACTIVITY_SUMMON)==0 and Duel.GetCustomActivityCount(511005064,c:GetControler(),ACTIVITY_SPSUMMON)==0 and e:GetHandler():GetFlagEffect(511005064)==0 and c:GetFlagEffect(511005064)==0 and c:IsType(TYPE_FUSION)
end

function scard.oath_fil(c)
  return c:IsType(TYPE_FUSION)
end