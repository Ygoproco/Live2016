--Quiz Panel - Slifer 10
os = require('os')
function c51102783.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(51102781,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetOperation(c51102783.operation)
	c:RegisterEffect(e1)
end
function c51102783.spfilter(c,e,tp)
	return c:IsCode(51102784) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c51102783.operation(e,tp,eg,ep,ev,re,r,rp)
	local endtime=0
	local check=true
	local start=os.time()
	local ct=0
	local bonus=0
	repeat
		if bonus~=6 and bonus~=12 and bonus~=18 then 
			Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(51102783,0))
		else
			if Duel.SelectYesNo(1-tp,aux.Stringid(51102783,1)) then
				ct=ct+1
			end
		end
		ct=ct+1
		bonus=bonus+1
		endtime=os.time()-start
		if endtime>10 then
			check=false
		end
	until check==false or ct>=20
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c51102783.spfilter,tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
	if check==true then
		Duel.Damage(tp,500,REASON_EFFECT)
	else
		if Duel.GetAttacker() then
			Duel.Destroy(Duel.GetAttacker(),REASON_EFFECT)
		end
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
