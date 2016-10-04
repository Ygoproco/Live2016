--Rank-Down-Magic Hope Fall
function c511000225.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c511000225.condition)
	e1:SetTarget(c511000225.target)
	e1:SetOperation(c511000225.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	c:RegisterEffect(e2)
end
function c511000225.filter(c,e,tp)
	local rk=c:GetRank()
	return rk>1 and c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_XYZ) and c:GetPreviousControler()==tp and c:IsSetCard(0x48)
		and Duel.IsExistingMatchingCard(c511000225.sfilter,tp,LOCATION_EXTRA,0,1,nil,rk,e,tp)
end
function c511000225.sfilter(c,rk,e,tp)
	return c:IsRankBelow(rk-1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c511000225.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511000225.filter,1,nil,e,tp)
end
function c511000225.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg~=nil end
	local g=eg:Filter(c511000225.filter,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511000225.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c511000225.sfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetRank(),e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=g:GetFirst()
	if sc then
		if tc:IsRelateToEffect(e) then
			Duel.Overlay(sc,Group.FromCards(tc))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
