--Rage Resynchro
function c511000900.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000900.target)
	e1:SetOperation(c511000900.activate)
	c:RegisterEffect(e1)
end
function c511000900.matfilter1(c,syncard,g2,slv)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and g2:CheckWithSumEqual(Card.GetLevel,slv-lv,1,99)
end
function c511000900.matfilter2(c,syncard)	
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER)
end
function c511000900.spfilter(c,e,tp)
	local lv=c:GetLevel()
	local g2=Duel.GetMatchingGroup(c511000900.matfilter2,tp,LOCATION_MZONE,0,nil,c)
	local g1=Duel.GetMatchingGroup(c511000900.matfilter1,tp,LOCATION_MZONE,0,nil,c,g2,lv)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g1:GetCount()>0
end
function c511000900.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c511000900.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingTarget(c511000900.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c511000900.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c511000900.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local lv=tc:GetLevel()
		local g2=Duel.GetMatchingGroup(c511000900.matfilter2,tp,LOCATION_MZONE,0,nil,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner=Duel.SelectMatchingCard(tp,c511000900.matfilter1,tp,LOCATION_MZONE,0,1,1,nil,tc,g2,lv)
		local sg=g2:SelectWithSumEqual(tp,Card.GetLevel,lv-tuner:GetFirst():GetLevel(),1,99)
		tuner:Merge(sg)
		Duel.SendtoGrave(tuner,REASON_MATERIAL+REASON_SYNCHRO)
		tc:SetMaterial(tuner)
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetOperation(c511000900.desop)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
			e2:SetLabel(0)
			e2:SetCountLimit(1)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	end
end
function c511000900.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()>0 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	else
		e:SetLabel(1)
	end
end
