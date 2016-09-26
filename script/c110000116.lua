--Armored Gravitation
function c110000116.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c110000116.target)
	e1:SetOperation(c110000116.activate)
	c:RegisterEffect(e1)
end
function c110000116.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsType(0x10000000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c110000116.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c110000116.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c110000116.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>4 then ft=4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c110000116.filter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			tc:RegisterFlagEffect(110000116,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetCondition(c110000116.tgcon)
		e1:SetOperation(c110000116.tgop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c110000116.tgfilter(c,fid)
	return c:GetFlagEffectLabel(110000116)==fid
end
function c110000116.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c110000116.tgfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c110000116.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c110000116.tgfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.SendtoGrave(tg,REASON_EFFECT)
end
