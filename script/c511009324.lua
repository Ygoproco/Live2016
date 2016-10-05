--Parasite Plant
function c511009324.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c511009324.target)
	e1:SetOperation(c511009324.operation)
	c:RegisterEffect(e1)
	
		--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11493868,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c511009324.eqtg)
	e4:SetOperation(c511009324.eqop)
	c:RegisterEffect(e4)
end

function c511009324.filter1(c)
	
	return c:IsFaceup() and c:IsCode(511002961)
end
function c511009324.filter2(c)
	return  c:GetEquipGroup():IsExists(Card.IsCode,1,nil,511002961)
end
function c511009324.spfilter(c,e,tp)
	return c:IsCode(511009344) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
end
function c511009324.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local sg=Duel.GetMatchingGroup(c511009324.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then
		if sg:GetCount()==0 then return false end
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingTarget(c511009324.filter1,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingTarget(c511009324.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c511009324.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,c511009324.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,2,0,0)
end
function c511009324.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==0 then return end
	Duel.SendtoGrave(tg,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511009324.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) then
		Duel.BreakEffect()
		Duel.SpecialSummonComplete()
		
		--equip Pfusioner
		local sg=Duel.GetMatchingGroup(c511009324.eqfilter,tp,LOCATION_GRAVE,0,nil)
		local eqtc=sg:GetFirst()
		while eqtc do
			if not Duel.Equip(tp,eqtc,tc,false) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c511009324.eqlimit)
			e1:SetLabelObject(tc)
			eqtc:RegisterEffect(e1)
			eqtc=sg:GetNext()
		end
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EFFECT_IMMUNE_EFFECT)
		e5:SetValue(c511009324.efilter)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e5)
	end
end


function c511009324.eqfilter(c)
	return c:GetCode()==511002961
end
function c511009324.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c511009324.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
		and te:IsActiveType(TYPE_MONSTER)
end
function c511009324.eqfilter2(c)
	return c:IsFaceup() and c:IsCode(511009344)
end
function c511009324.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c511009324.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c511009324.eqfilter,tp,LOCATION_DECK,0,1,nil) end
		local g=Duel.SelectTarget(tp,c511009324.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c511009324.eqop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12152769,2))
		local g=Duel.SelectMatchingCard(tp,c511009324.eqfilter,tp,LOCATION_DECK,0,1,1,nil)
		local ec=g:GetFirst()
		if ec then
			Duel.HintSelection(g)
			if not Duel.Equip(tp,ec,tc,true) then return end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c511009324.eqlimit)
			e1:SetLabelObject(tc)
			ec:RegisterEffect(e1)
			Duel.GetControl(tc,tp)
		end
	end