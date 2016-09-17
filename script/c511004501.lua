--Dimension U-Turn
local id,ref=GIR()

function ref.start(c)
  --Special Summon
  local e1=c:AddActivateProc(0,id)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetTarget(CCF(ref.tg,ref.tg_check,ref.tg_target))
  e1:SetOperation(ref.op)
  --Banish
  local e2=c:CreateGraveBanishEffect()
  e2:SetEffectDescription(id,1)
  e2:SetCategory(CATEGORY_REMOVE)
  e2:SetTarget(CCF(ref.btg,ref.btg_check))
  e2:SetOperation(ref.bop)
  e2:Register(c)
end

--Special Summon
function ref.tg_target(e,tp,eg,ep,ev,re,r,rp,chkc)
  return chkc:TargetFilterCheck(Card.IsCanBeSpecialSummoned,tp,LOCATION_REMOVED,e,0,tp,false,false)
end

function ref.tg_check(e,tp,eg,ep,ev,re,r,rp)
  return Duel.PlayerFilterTargetCheck(Card.IsCanBeSpecialSummoned,tp,LOCATION_REMOVED,nil,e,0,tp,false,false)
end

function ref.tg(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectTarget(tp,Duel.IsCanBeSpecialSummoned,tp,LOCATION_REMOVED,0,1,1,nil,e,0,tp,false,false)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function ref.op(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc,hasCard=Duel.SingleCheckedTarget(e,Card.IsCanBeSpecialSummoned,e,0,tp,false,false)
  if not hasCard then return end
  tc:SpecialSummon(0,tp)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
  e1:ResetEndOrLeave()
  e1:SetOperation(WithHandler(Card.Banish))
  tc:RegisterEffect(e1,true)
end

--Banish
function ref.btg_check(e,tp,eg,ep,ev,re,r,rp)
  return Duel.PlayerFilterCheck(Card.IsAbleToRemove,tp,LOCATION_MZONE)
end

function ref.btg(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

function ref.bop(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.PlayerFilterCheck(Card.IsAbleToRemove,tp,LOCATION_MZONE) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local tc=Duel.SelectSingleCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE)
  Duel.TempRemove(e,tc,POS_FACEUP,REASON_EFFECT,id)
end
