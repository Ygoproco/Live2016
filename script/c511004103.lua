--Xyz Reborn Plus
--scripted by: urielkama
function c511004103.initial_effect(c)
--special summon/attach
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(511004103,0))
e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetTarget(c511004103.tg)
e1:SetOperation(c511004103.op)
c:RegisterEffect(e1)
end
function c511004103.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c511004103.tg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingTarget(c511004103.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
local g=Duel.SelectTarget(tp,c511004103.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,LOCATION_GRAVE)
end
function c511004103.op(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local tc=Duel.GetFirstTarget()
if Duel.GetLocationCount(tp,LOCATION_MZONE,0)<=0 and not c:IsRelateToEffect(e) then return end
if tc then
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(511004103,1))
e1:SetType(EFFECT_TYPE_IGNITION)
e1:SetRange(LOCATION_MZONE)
e1:SetCountLimit(1)
e1:SetCost(c511004103.cost)
e1:SetOperation(c511004103.op2)
e1:SetReset(RESET_EVENT+0xfe0000)
e1:SetLabelObject(c)
tc:RegisterEffect(e1)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(tc,Group.FromCards(c))	
		end
	end
end
function c511004103.cost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
Duel.SendtoGrave(e:GetLabelObject(),REASON_COST)
end
function c511004103.op2(e,tp,eg,ep,ev,re,r,rp)
Duel.Draw(tp,2,REASON_EFFECT)
end