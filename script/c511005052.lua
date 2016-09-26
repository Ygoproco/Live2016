--Photon Specter
--  By Shad3

local scard=c511005052

function scard.initial_effect(c)
  --Trigger
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetRange(LOCATION_GRAVE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetDescription(aux.Stringid(511005052,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetCondition(scard.cd)
  e1:SetCost(scard.cs)
  e1:SetTarget(scard.tg)
  e1:SetOperation(scard.op)
  c:RegisterEffect(e1)
end

function scard.cd(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker():IsControler(1-tp) and not Duel.GetAttackTarget()
end

function scard.cs(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
  Duel.Remove(e:GetHandler(),nil,REASON_COST)
end

function scard.sm_fil(c,e,tp)
  return c:IsSetCard(0x55) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end

function scard.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and scard.sm_fil(chkc) end
  if chk==0 then return Duel.IsExistingTarget(scard.sm_fil,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Duel.SelectTarget(tp,scard.sm_fil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp),1,tp,0)
end

function scard.op(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_DISABLE_EFFECT)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      local e2=e1:Clone()
      e2:SetCode(EFFECT_DISABLE)
      local e3=e1:Clone()
      e3:SetCode(EFFECT_UPDATE_ATTACK)
      e3:SetValue(-1000)
      local e4=e1:Clone()
      e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
      e4:SetValue(1)
      e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e3)
      tc:RegisterEffect(e2)
      tc:RegisterEffect(e1)
      tc:RegisterEffect(e4)
    end
    Duel.SpecialSummonComplete()
  end
end