--Monster Replace
function c511000461.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c511000461.target)
	e1:SetOperation(c511000461.activate)
	c:RegisterEffect(e1)
end
function c511000461.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c511000461.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 
	and Duel.IsExistingMatchingCard(c511000461.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c511000461.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local pos=tc:GetPosition()
	local g=Duel.GetMatchingGroup(c511000461.filter,tp,LOCATION_HAND,0,nil)
	if tc and tc:IsRelateToEffect(e) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			local tg=g:GetMaxGroup(Card.GetAttack)
			if tg:GetCount()>1 then
				local sg=tg:Select(tp,1,1,tc)
				Duel.HintSelection(sg)
				Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_MZONE,pos,true)
			else
				Duel.MoveToField(tg:GetFirst(),tp,tp,LOCATION_MZONE,pos,true)
			end
		end
	end
end
