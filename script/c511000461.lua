--Monster Replace
function c511000461.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000461.target)
	e1:SetOperation(c511000461.activate)
	c:RegisterEffect(e1)
end
function c511000461.filter(c,tp)
	return c:IsAbleToHand() and Duel.IsExistingMatchingCard(c511000461.filter2,tp,LOCATION_HAND,0,1,c,c:GetAttack())
end
function c511000461.filter2(c,atk)
	return c:IsType(TYPE_MONSTER) and c:GetAttack()>atk
end
function c511000461.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c511000461.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c511000461.filter,tp,LOCATION_MZONE,0,1,nil,tp) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c511000461.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c511000461.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local pos=tc:GetPosition()
	if tc and tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c511000461.filter2,tp,LOCATION_HAND,0,tc,tc:GetAttack())
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			local sc=g:Select(tp,1,1,tc):GetFirst()
			Duel.MoveToField(sc,tp,tp,LOCATION_MZONE,pos,true)
			Duel.SpecialSummonComplete()
		end
	end
end
