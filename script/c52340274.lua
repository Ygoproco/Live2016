--ギャラクシー・クィーンズ・ライト
function c52340274.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c52340274.target)
	e1:SetOperation(c52340274.activate)
	c:RegisterEffect(e1)
end
function c52340274.filter1(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(7) and Duel.IsExistingMatchingCard(c52340274.filter2,tp,LOCATION_MZONE,0,1,c,c:GetLevel())
end
function c52340274.filter2(c,lv)
	local clv=c:GetLevel()
	return c:IsFaceup() and clv>0 and clv~=lv
end
function c52340274.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c52340274.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c52340274.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c52340274.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c52340274.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lv=tc:GetLevel()
		local g=Duel.GetMatchingGroup(c52340274.filter2,tp,LOCATION_MZONE,0,tc,lv)
		local lc=g:GetFirst()
		while lc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			lc:RegisterEffect(e1)
			lc=g:GetNext()
		end
	end
end
