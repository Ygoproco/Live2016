--法の聖典
--Scripture of Law
--Script by nekrozar
function c7637.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,7637)
	e1:SetLabel(0)
	e1:SetCost(c7637.cost)
	e1:SetTarget(c7637.target)
	e1:SetOperation(c7637.activate)
	c:RegisterEffect(e1)
end
function c7637.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c7637.filter1(c,e,tp)
	return c:IsSetCard(0xf4) and Duel.IsExistingMatchingCard(c7637.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetOriginalAttribute())
end
function c7637.filter2(c,e,tp,att)
	return c:IsSetCard(0xf4) and c:GetOriginalAttribute()~=att and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
end
function c7637.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.CheckReleaseGroup(tp,c7637.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c7637.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetOriginalAttribute())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c7637.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local att=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c7637.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,att)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	end
end