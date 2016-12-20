--連鎖召喚
--Chain Summon
--Script by mercury233
function c100214008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100214008.target)
	e1:SetOperation(c100214008.activate)
	c:RegisterEffect(e1)
end
function c100214008.cfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c100214008.cfilter2(c,r)
	return c:IsType(TYPE_XYZ) and c:GetRank()==r and c:IsFaceup()
end
function c100214008.filter(c,e,tp,r)
	return c:IsType(TYPE_XYZ) and c:GetRank()<r
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100214008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c100214008.cfilter,tp,LOCATION_MZONE,0,nil)
	local rg,r=g:GetMinGroup(Card.GetRank)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100214008.cfilter2(chkc,r) end
	if chk==0 then return g:GetCount()>=2 and rg:IsExists(Card.IsCanBeEffectTarget,1,nil,e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100214008.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,r) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=rg:FilterSelect(tp,Card.IsCanBeEffectTarget,1,1,nil,e)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100214008.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local r=tc:GetRank()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100214008.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,r)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(100214008,RESET_EVENT+0x1fe0000,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(tc)
		e2:SetCondition(c100214008.retcon)
		e2:SetOperation(c100214008.retop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c100214008.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(100214008)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c100214008.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end