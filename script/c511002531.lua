--浅すぎた墓穴
function c511002531.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c511002531.target)
	e1:SetOperation(c511002531.activate)
	c:RegisterEffect(e1)
end
function c511002531.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511002531.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		return Duel.IsExistingTarget(c511002531.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c511002531.filter,1-tp,LOCATION_GRAVE,0,1,nil,e,1-tp)
			and Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,c511002531.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local oc=nil
	if Duel.SelectYesNo(1-tp,aux.Stringid(102380,0)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local og=Duel.SelectTarget(1-tp,c511002531.filter,1-tp,LOCATION_GRAVE,0,1,1,nil,e,1-tp)
		oc=og:GetFirst()
	end
	local sc=sg:GetFirst()
	if oc~=nil then
		sg:AddCard(oc)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),PLAYER_ALL,sc:GetOwner())
	e:SetLabelObject(sc)
end
function c511002531.activate(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local oc=g:GetFirst()
	if oc and oc==sc then oc=g:GetNext() end
	if sc and sc:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	if oc and oc:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(oc,0,1-tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
end
