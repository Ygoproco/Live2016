--Ultimate Dragon
function c511001816.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001816.target)
	e1:SetOperation(c511001816.activate)
	c:RegisterEffect(e1)
end
c511001816.fit_monster={23995346}
function c511001816.filter(c,e,tp,m)
	local cd=c:GetCode()
	if cd~=23995346 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	local mg2=Duel.GetMatchingGroup(c511001816.filter2,tp,LOCATION_DECK,0,nil,c)
	m:Merge(mg2)
	if m:IsContains(c) then
		m:RemoveCard(c)
		result=m:IsExists(Card.IsCode,3,nil,89631139)
		m:AddCard(c)
	else
		result=m:IsExists(Card.IsCode,3,nil,89631139)
	end
	m:Sub(mg2)
	return result
end
function c511001816.filter2(c,rc)
	return c:IsCanBeRitualMaterial(rc) and c:GetLevel()>0
end
function c511001816.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c511001816.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511001816.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c511001816.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		local mg2=Duel.GetMatchingGroup(c511001816.filter2,tp,LOCATION_DECK,0,nil,tc)
		mg:Merge(mg2)
		mg:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:FilterSelect(tp,Card.IsCode,3,3,nil,89631139)
		tc:SetMaterial(mat)
		local mat1=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		mat:Sub(mat1)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_RELEASE+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
