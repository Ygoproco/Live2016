--Quiz Panel - Obelisk 20
os = require('os')
function c51102782.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(51102781,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetOperation(c51102782.operation)
	c:RegisterEffect(e1)
end
function c51102782.spfilter(c,e,tp)
	return c:IsCode(51101940) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c51102782.operation(e,tp,eg,ep,ev,re,r,rp)
	local endtime=0
	local check=true
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)
	local lv=g:GetSum(Card.GetLevel)
	local start=os.time()
	local ct=0
	local dn=0
	repeat
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(51102782,0))
		dn=Duel.AnnounceNumber(1-tp,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,
		44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,
		93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126--,127,128,129,130,
		--131,132,133,134,135,136,137,138,139,140
		)
		ct=ct+dn
		endtime=os.time()-start
		if endtime>10 or ct>lv then
			check=false
		end
	until check==false or dn<140 or not Duel.SelectYesNo(tp,aux.Stringid(51102782,1))
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c51102782.spfilter,tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
	if lv==ct then
		Duel.Damage(tp,800,REASON_EFFECT)
	else
		if Duel.GetAttacker() then
			Duel.Destroy(Duel.GetAttacker(),REASON_EFFECT)
		end
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end
