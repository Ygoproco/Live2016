--Xyz Battle Chain
--scripted by:urielkama
--fixed by MLD
function c511004106.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c511004106.condition)
	e1:SetTarget(c511004106.target)
	e1:SetOperation(c511004106.activate)
	c:RegisterEffect(e1)
end
function c511004106.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c511004106.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c511004106.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c511004106.cfilter,1,nil) and Duel.IsChainNegatable(ev) 
		and Duel.IsExistingMatchingCard(c511004106.filter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c511004106.filter,tp,0,LOCATION_MZONE,1,nil)
end
function c511004106.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511004106.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511004106.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c511004106.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c511004106.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 and tc and tc:IsRelateToEffect(e) and Duel.GetTurnPlayer()~=tp 
		and Duel.GetActivityCount(1-tp,ACTIVITY_BATTLE_PHASE)==0 and (not Duel.IsAbleToEnterBP() or Duel.GetCurrentPhase()==PHASE_END) then 
		local g=Duel.GetMatchingGroup(c511004106.filter,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			local sg=g:Select(1-tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.CalculateDamage(sg:GetFirst(),tc)
		end
	end
end
