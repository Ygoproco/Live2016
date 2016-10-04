--Cross Shift
function c511000542.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c511000542.target)
	e1:SetOperation(c511000542.activate)
	c:RegisterEffect(e1)
end
function c511000542.filter(c)
	return c:GetLevel()<=4 and c:IsType(TYPE_MONSTER)
end
function c511000542.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 
	and Duel.IsExistingMatchingCard(c511000542.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c511000542.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.SelectMatchingCard(tp,c511000542.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,1,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.MoveToField(g1:GetFirst(),tp,tp,LOCATION_MZONE,POS_FACEUP+POS_FACEDOWN,true)
	end
end
